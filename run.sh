#!/usr/bin/env bash
set -Eeuo pipefail

# Run from any working directory.
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_BIN="${PYTHON_BIN:-python}"
PIP_BIN="${PIP_BIN:-$PYTHON_BIN -m pip}"
HF_ENDPOINT="${HF_ENDPOINT:-https://hf-mirror.com}"
HF_CACHE_DIR="${HF_CACHE_DIR:-$ROOT_DIR/huggingface_cache}"
MODEL_OUTPUT_DIR="${MODEL_OUTPUT_DIR:-$ROOT_DIR/results/models}"

log()  { printf '\n[INFO] %s\n' "$*"; }
warn() { printf '\n[WARN] %s\n' "$*" >&2; }
die()  { printf '\n[ERROR] %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'USAGE'
Usage: ./run.sh [options]

This script is opt-in: running it without options only displays this help.
Options:
  --install-python-deps       Install requirements.txt
  --install-pytorch           Install the pinned PyTorch 2.1.2 CUDA 12.1 stack
  --download-datasets         Download/unpack CLEVR; run data/kaggle.py only if present
  --download-hf-models        Download the Hugging Face models and BLIP2 weights
  --download-editor-checkpoints
                              Download the published MEND/SERAC checkpoints from ModelScope
  --all                       Run all of the above steps
  -h, --help                  Show this help

Environment overrides:
  PYTHON_BIN, PIP_BIN, HF_ENDPOINT, HF_CACHE_DIR, MODEL_OUTPUT_DIR
  PYTORCH_INDEX_URL (default: https://download.pytorch.org/whl/cu121)

Install system tools (aria2c, unzip) yourself before dataset/model downloads.
Review each download's license, size, and storage requirements before running it.
USAGE
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

pip_run() {
  # PIP_BIN is intentionally word-split to allow e.g. "python -m pip".
  # shellcheck disable=SC2086
  $PIP_BIN "$@"
}

install_python_deps() {
  log "Installing Python dependencies from requirements.txt"
  pip_run install -r "$ROOT_DIR/requirements.txt"
}

install_pytorch() {
  log "Installing the repository's pinned PyTorch/CUDA 12.1 stack"
  pip_run install \
    torch==2.1.2 torchvision==0.16.2 torchaudio==2.1.2 \
    --index-url "${PYTORCH_INDEX_URL:-https://download.pytorch.org/whl/cu121}"
}

download_datasets() {
  require_command aria2c
  require_command unzip
  local dataset_dir="$ROOT_DIR/data/clevr_dataset"
  mkdir -p "$dataset_dir"
  cd "$dataset_dir"

  local archive="CLEVR_CoGenT_v1.0.zip"
  local url="https://dl.fbaipublicfiles.com/clevr/CLEVR_CoGenT_v1.0.zip"
  if [[ ! -f "$archive" ]]; then
    log "Downloading CLEVR CoGenT"
    aria2c -x 16 -s 16 --summary-interval=5 -o "$archive" "$url"
  else
    warn "$archive already exists; skipping download"
  fi

  if [[ ! -d "CLEVR_CoGenT_v1.0" ]]; then
    log "Extracting CLEVR CoGenT"
    unzip -q -n "$archive"
  else
    warn "CLEVR_CoGenT_v1.0 already exists; skipping extraction"
  fi

  # This file is intentionally not tracked (it may contain local Kaggle setup).
  if [[ -f "$ROOT_DIR/data/kaggle.py" ]]; then
    log "Running local data/kaggle.py"
    "$PYTHON_BIN" "$ROOT_DIR/data/kaggle.py"
  else
    warn "data/kaggle.py not found; skipping the optional Kaggle dataset step"
  fi
}

download_hf_models() {
  require_command aria2c
  mkdir -p "$HF_CACHE_DIR"
  export HF_ENDPOINT

  local downloader=""
  if command -v hf >/dev/null 2>&1; then
    downloader="hf"
  elif command -v huggingface-cli >/dev/null 2>&1; then
    downloader="huggingface-cli"
  else
    die "Neither 'hf' nor 'huggingface-cli' is available. Install huggingface_hub first."
  fi

  download_model() {
    local model_id="$1"
    local local_dir="$2"
    if [[ -d "$local_dir" ]]; then
      warn "$local_dir already exists; skipping $model_id"
      return
    fi
    log "Downloading $model_id"
    if [[ "$downloader" == "hf" ]]; then
      hf download "$model_id" --local-dir "$local_dir"
    else
      huggingface-cli download "$model_id" --local-dir "$local_dir"
    fi
  }

  download_model google-bert/bert-base-uncased "$HF_CACHE_DIR/bert-base-uncased"
  download_model distilbert/distilbert-base-cased "$HF_CACHE_DIR/distilbert-base-cased"
  download_model liuhaotian/llava-v1.5-7b "$HF_CACHE_DIR/llava-v1.5-7b"
  download_model facebook/opt-6.7b "$HF_CACHE_DIR/opt-6.7b"
  download_model facebook/opt-1.3b "$HF_CACHE_DIR/opt-1.3b"
  download_model Qwen/Qwen2-7B "$HF_CACHE_DIR/Qwen2-7B"
  download_model Qwen/Qwen2-VL-7B-Instruct "$HF_CACHE_DIR/Qwen2-VL"
  download_model lmsys/vicuna-7b-v1.5 "$HF_CACHE_DIR/vicuna-7b-v1.5"
  download_model openai/clip-vit-large-patch14-336 "$HF_CACHE_DIR/clip-vit-large-patch14-336"

  download_file() {
    local filename="$1"
    local url="$2"
    if [[ -f "$HF_CACHE_DIR/$filename" ]]; then
      warn "$filename already exists; skipping"
      return
    fi
    log "Downloading $filename"
    aria2c -x 16 -s 16 -d "$HF_CACHE_DIR" -o "$filename" "$url"
  }

  download_file blip2_pretrained_opt6.7b.pth \
    https://storage.googleapis.com/sfr-vision-language-research/LAVIS/models/BLIP2/blip2_pretrained_opt6.7b.pth
  download_file eva_vit_g.pth \
    https://storage.googleapis.com/sfr-vision-language-research/LAVIS/models/BLIP2/eva_vit_g.pth
}

download_editor_checkpoints() {
  require_command modelscope
  mkdir -p "$MODEL_OUTPUT_DIR/MEND" "$MODEL_OUTPUT_DIR/SERAC_MULTI"
  local model_id="zukia12/mllm_ke"

  download_ms_file() {
    local filename="$1"
    local destination="$2"
    if [[ -f "$destination/$filename" ]]; then
      warn "$filename already exists; skipping"
      return
    fi
    log "Downloading ModelScope checkpoint: $filename"
    modelscope download --model "$model_id" "$filename" --local_dir "$destination"
  }

  download_ms_file llava_mend_clevr-step_12000.pt "$MODEL_OUTPUT_DIR/MEND"
  download_ms_file blip2_mend_clevr-step_3000.pt "$MODEL_OUTPUT_DIR/MEND"
  download_ms_file llava_serac_clevr-step_14000.pt "$MODEL_OUTPUT_DIR/SERAC_MULTI"
  download_ms_file llava_serac_supple-step_12000.pt "$MODEL_OUTPUT_DIR/SERAC_MULTI"
  download_ms_file blip2_serac_clevr-step_6000.pt "$MODEL_OUTPUT_DIR/SERAC_MULTI"
  download_ms_file blip2_serac_supple-step_6000.pt "$MODEL_OUTPUT_DIR/SERAC_MULTI"
}

if [[ $# -eq 0 ]]; then
  usage
  exit 0
fi

DO_PYTHON_DEPS=0
DO_PYTORCH=0
DO_DATASETS=0
DO_HF_MODELS=0
DO_EDITOR_CHECKPOINTS=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-python-deps) DO_PYTHON_DEPS=1 ;;
    --install-pytorch) DO_PYTORCH=1 ;;
    --download-datasets) DO_DATASETS=1 ;;
    --download-hf-models) DO_HF_MODELS=1 ;;
    --download-editor-checkpoints) DO_EDITOR_CHECKPOINTS=1 ;;
    --all)
      DO_PYTHON_DEPS=1
      DO_PYTORCH=1
      DO_DATASETS=1
      DO_HF_MODELS=1
      DO_EDITOR_CHECKPOINTS=1
      ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" ;;
  esac
  shift
done

[[ "$DO_PYTHON_DEPS" -eq 0 ]] || install_python_deps
[[ "$DO_PYTORCH" -eq 0 ]] || install_pytorch
[[ "$DO_DATASETS" -eq 0 ]] || download_datasets
[[ "$DO_HF_MODELS" -eq 0 ]] || download_hf_models
[[ "$DO_EDITOR_CHECKPOINTS" -eq 0 ]] || download_editor_checkpoints

log "Requested setup steps completed."
