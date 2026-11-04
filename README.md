# AKE

AKE is a research codebase for multimodal knowledge editing. The repository includes the EasyEdit-based editing framework, multimodal datasets/trainers, and experiment entry points.

> **Status:** Research code. Model/data download workflows and environment combinations have not yet been validated end-to-end on a clean machine. Treat the commands below as setup guidance, not a guarantee that every experiment is reproducible without additional configuration.

## Repository layout

- `easyeditor/`: editing algorithms, editors, datasets, trainers, evaluation utilities, and model-specific code.
- `multimodal_edit.py`: command-line entry point for multimodal FT, MEND, and SERAC experiments.
- `requirements.txt`: top-level Python dependencies.
- `run.sh`: opt-in setup/download helper. It does not install or download anything unless an explicit option is supplied.
- `data/`: local datasets and dataset preparation assets. Large/private data are not expected to be committed.
- `results/`: local experiment outputs and downloaded editing checkpoints.

## Environment

Use an isolated Python environment. The exact Python, PyTorch, CUDA, Transformers, and model-specific dependency combination must match the experiment being run.

Install the top-level dependencies:

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

The repository also contains vendored model components with their own dependency metadata. In particular, the mPLUG-Owl2 component may require versions that differ from the top-level pins. Do not install every nested component's requirements into one environment blindly; create a separate environment or resolve and test a compatible set for the selected experiment.

The current top-level requirements and the model-specific metadata have not yet been reconciled. A tested lock file should only be added after validating the target Python/CUDA platform.

## Setup helper

Running the script without arguments only prints help:

```bash
bash run.sh --help
```

Each operation is explicit:

```bash
# Install top-level Python dependencies
bash run.sh --install-python-deps

# Optional: install the repository's pinned PyTorch 2.1.2 / CUDA 12.1 stack
bash run.sh --install-pytorch

# Optional: download CLEVR and run data/kaggle.py if that local file exists
bash run.sh --download-datasets

# Optional: download Hugging Face models and BLIP2 weights
bash run.sh --download-hf-models

# Optional: download MEND/SERAC checkpoints from ModelScope
bash run.sh --download-editor-checkpoints
```

Before downloading, check available disk space, model/data licenses, credentials, and network access. Install `aria2c` and `unzip` yourself for dataset/model downloads. Kaggle credentials and the optional `data/kaggle.py` preparation script are local setup and are not included in this repository.

The helper supports `PYTHON_BIN`, `PIP_BIN`, `HF_ENDPOINT`, `HF_CACHE_DIR`, and `MODEL_OUTPUT_DIR` environment overrides.

## Running multimodal experiments

The entry point exposes the following required arguments:

- `--model`: `llava`, `blip2`, or `qwen-vl`
- `--method`: `MEND`, `SERAC`, `FT-L`, or `FT-V`
- `--mode`: `train` or `eval`
- `--config_path`: hyperparameter configuration
- `--train_json_path` and `--eval_json_path`: dataset JSON paths
- `--dataset_type`: `AttributeDataset` or `SuppleDataset`
- `--image` and `--device`: required by the current argument parser

Example shape (replace paths and device with values valid for your environment):

```bash
python multimodal_edit.py \
  --model llava \
  --method MEND \
  --mode train \
  --config_path path/to/config.yaml \
  --train_json_path path/to/train.json \
  --eval_json_path path/to/eval.json \
  --dataset_type AttributeDataset \
  --image path/to/image \
  --device 0
```

Check the selected algorithm's hyperparameter file and dataset implementation before launching a long run. Some algorithms have additional checkpoint or model-specific requirements.

## Data, model weights, and outputs

Do not commit downloaded model weights, private datasets, credentials, or experiment outputs. Keep reproducibility metadata (configuration, command line, seed, package versions, and relevant dataset/model identifiers) in lightweight text files alongside experiment results.

## Current maintenance notes

- The top-level dependency pins and nested model dependency metadata need compatibility testing.
- The setup script intentionally separates installation and large downloads into explicit options to avoid accidental, expensive runs.
- Jupyter checkpoint folders and Python cache files are ignored by Git; existing tracked checkpoint copies should be reviewed before deletion.
- Algorithm behavior has not been changed as part of this repository-structure cleanup.
