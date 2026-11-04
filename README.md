# AKE: Visual Knowledge Editing

This branch contains the AKE visual knowledge-editing implementation, with model-specific helpers for BLIP-2, LLaVA, and Qwen-VL.

## Layout

- `main.py`: experiment entry point and configuration loading.
- `edit.py`: editing, loss computation, and evaluation flow.
- `helpers/`: model loading, dataset preparation, feature extraction, and editing helpers.
- `config/`: per-model YAML configurations.
- `dataset/`: dataset metadata and image/mask assets.

## Run

Run commands from this branch's repository root so relative paths in the YAML files resolve consistently:

```bash
python main.py --config config/llava.yaml
python main.py --config config/blip2.yaml
python main.py --config config/qwenvl.yaml
```

The configurations contain experiment parameters. Do not change those values merely to make a local environment work; supply the required data and model directories at the paths specified by the configuration, or make a deliberate local copy of a configuration.

## External assets

The repository may not contain every original image corpus, pretrained checkpoint, generated ZM-K cache, or experiment output. Prepare those assets separately. Existing dataset JSON files, images, masks, archives, and result files are research artifacts and must not be treated as disposable cache.

## Environment

This branch does not currently provide a fully validated, isolated dependency lockfile. Install the model-specific dependencies in a dedicated environment and verify the selected model stack before running a full experiment. In particular, Qwen3-VL requires a recent Transformers release and compatible Qwen-VL utilities.

## Reproducibility and scope

The editing implementation and experiment hyperparameters are research code. Repository maintenance should be limited to documentation, path portability, and removal of disposable interpreter/editor caches. Do not change model structure, loss definitions, optimization logic, data selection, or experiment defaults as part of cleanup.
