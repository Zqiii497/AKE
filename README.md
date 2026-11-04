# VisEdit: VEAD and P-Track

This branch contains the VEAD visual-language-model editing implementation and P-Track representation analysis. It is maintained independently from `main` and the `akedit` experiments.

## Layout

- `vead_train.py`, `vead_test.py`: VEAD training and evaluation entry points.
- `editor/vllm_editors/vead/`: VEAD editor and adaptor.
- `editor/vllms_for_edit/`: BLIP-2, LLaVA, MiniGPT-4, and Qwen3-VL wrappers.
- `evaluation/`: editor evaluation and AKE metric aggregation.
- `p_track/`: layer, attention, and MLP representation tracking.
- `configs/`: VEAD and P-Track model configurations.
- `dataset/`: dataset classes and prepared-data adapters.

## Important source-file blocker

The current branch imports `BaseVLLMEditData` from `dataset.vllm` in several modules, but `dataset/vllm.py` is absent from the branch. Only a Python 3.10 bytecode cache remains at `dataset/__pycache__/vllm.cpython-310.pyc`. That cache is not a reliable substitute for the missing source and is intentionally retained as a recovery artifact.

**Restore the original `dataset/vllm.py` before attempting to train or evaluate.** Do not replace it with a newly guessed implementation: its data representation and image-loading behavior are part of the experiment implementation.

## Environment and model checkpoints

The environment script installs packages, downloads the CLEVR dataset, and downloads model checkpoints. Review the script before running it, and use an isolated environment. It assumes a Linux/CUDA setup and may require system package-manager privileges.

Model directories are resolved by `utils/GLOBAL.py` under `huggingface_cache/` by default. The Qwen3-VL configuration expects `huggingface_cache/Qwen3-VL-8B-Instruct`; BLIP-2 and LLaVA use their corresponding local directories. You can override these locations with the `AKE_MODEL_ROOT`, `AKE_QWENVL_PATH`, `AKE_BLIP2_PATH`, and `AKE_LLAVA_PATH` environment variables.

## Training examples

Run from the repository root. The supplied `run.sh` contains example commands for Qwen3-VL, BLIP-2, and LLaVA on the attribute and supplementary datasets. For attribute data, the localization image root is explicitly set to the CLEVR image directory; supplementary data uses its black reference image.

The example data paths under `data/` are external and are not included in this branch. Prepare the JSON files and image directories before running the examples.

## Evaluation

- `vead_test.py` evaluates an editor on the selected dataset.
- `evaluation/ake_runner.py` is an AKE-oriented evaluation entry point.
- `evaluation/vllm_editor_eval.py` implements the shared evaluation procedure.

The evaluation entry points have not been validated end to end. In particular, the missing `dataset/vllm.py` currently prevents normal imports.

## Maintenance boundary

Maintenance changes are limited to cache cleanup, path/launcher/documentation consistency, and clearly isolated command-line wiring. The VEAD algorithm, model architecture, adaptor, loss terms, training schedule, data transformations, and configuration hyperparameters are not intentionally changed.

No GPU training or full end-to-end validation is implied by this README.
