# AKE Visual Editing (VEAD)

This branch contains the VEAD visual-language-model editing implementation, its training/evaluation entry points, and P-Track analysis code.

## Layout

- `vead_train.py`, `vead_test.py`: VEAD training and testing entry points.
- `editor/vllm_editors/vead/`: VEAD editor and adaptor implementation.
- `editor/vllms_for_edit/`: BLIP-2, LLaVA, MiniGPT-4, and Qwen3-VL wrappers.
- `dataset/`: dataset implementations and AKE dataset adapters.
- `evaluation/`: editor evaluation and AKE metric aggregation.
- `p_track/`: representation tracking utilities.
- `configs/`: editor and model configurations.

## Environment and models

Use a dedicated Python environment for this branch. Install the dependencies in `requirements.txt`, then install a PyTorch build compatible with the host CUDA runtime. The exact environment has not been validated end-to-end across all model families.

The Qwen3-VL wrapper requires Transformers >= 4.57.0. The environment script downloads Qwen3-VL-8B-Instruct into `huggingface_cache/Qwen3-VL-8B-Instruct`, matching `utils/GLOBAL.py`. Review `env.sh` before running it: it installs packages and downloads large datasets and model checkpoints.

## Data

The training commands in `run.sh` expect prepared CLEVR and supplementary datasets under `data/`. These data assets are not all tracked in this branch. Keep original dataset files, images, masks, archives, model checkpoints, and experiment outputs; they are not disposable caches.

## Dataset implementation

`dataset/vllm.py` is present and defines `BaseVLLMEditData`, the shared data container and image-loading implementation used by the AKE dataset adapters, VEAD editor, and evaluation code. Keep this source file intact; its request/generality/locality data contract is part of the experiment implementation.

## Entry points

Example commands are maintained in `run.sh`. Check the dataset paths and model availability before launching them. The evaluation entry point is `evaluation/ake_runner.py`.

## Reproducibility and scope

The VEAD adaptor, model wrappers, training objectives, and P-Track implementation are research code. Cleanup must not alter algorithms, model structure, loss functions, training strategy, or hyperparameter defaults. This branch has received static maintenance only; no GPU training or end-to-end experiment is claimed.
