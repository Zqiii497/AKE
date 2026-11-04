# AKE: Multimodal Knowledge Editing

This branch contains the AKE editing experiments implemented with BLIP-2, LLaVA, and Qwen-VL. It is maintained independently from the repository's `main` branch and from the VEAD implementation in `visedit`.

## Repository layout

- `main.py`: experiment entry point and configuration parsing.
- `edit.py`: model editing and optimization implementation.
- `helpers/`: model loading, data preparation, feature extraction, and editing helpers.
- `config/`: model-specific YAML configurations.
- `dataset/dataset/`: prepared AKE JSON files.
- `dataset/images_masks/`: generated mask assets and their metadata.
- `tools/`, `llava/`: supporting utilities and the LLaVA implementation.

## Environment

This branch does not currently include a dedicated, fully pinned dependency lock file. Install a PyTorch build compatible with your CUDA runtime, then install the Python packages required by the selected model backend. The Qwen-VL path uses Transformers, `qwen-vl-utils`, and the Qwen3-VL model implementation; BLIP-2 and LLaVA have their own model-specific requirements.

Do not assume one environment is compatible with all three backends. Record the Python, PyTorch, CUDA, Transformers, and model checkpoint versions used for each experiment.

## Model checkpoints

The YAML files use paths relative to this repository:

- BLIP-2: `huggingface_cache/blip2-opt-6.7b`
- LLaVA: `huggingface_cache/llava-v1.5-7b`
- Qwen3-VL: `huggingface_cache/Qwen3-VL-8B-Instruct`

The model directories must be downloaded or prepared separately. Update only path values in the YAML files when your local directory layout differs.

## Data

The repository includes prepared JSON and mask assets, but the original CLEVR images and some generated image directories are external or ignored. Prepare those files before running an experiment. Do not delete or regenerate the tracked JSON, mask images, ZIP archives, or experiment assets as part of cache cleanup.

## Run

Run commands from the repository root:

```bash
python main.py --config config/blip2.yaml
python main.py --config config/llava.yaml
python main.py --config config/qwenvl.yaml
```

Additional command-line arguments can override the YAML values. Check that every configured image, mask, dataset, model, and output path exists before starting.

## Maintenance boundary

Cleanup commits on this branch remove generated Python/Jupyter/editor caches and normalize machine-specific paths. The editing implementation, model architecture, losses, data transformations, training strategy, and experiment hyperparameters are intentionally left unchanged.

The commands above are documented entry points, not a claim that every backend has been tested end to end. No GPU training or full experiment validation is implied by this README.
