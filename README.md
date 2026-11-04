# AKE: Our Visual Knowledge Editing Method

This branch contains the implementation of **AKE, the method developed in this project**. It is our own method track, separate from the EasyEdit reproduction/benchmark code on `main` and the third-party VisEdit-based experiments on `visedit`.

AKE should not be described as a generic alias for the whole repository, as an EasyEdit baseline, or as the original VisEdit method.

## Method implementation

The current implementation provides a visual-language-model editing pipeline for BLIP-2, LLaVA, and Qwen-VL-family models. The code includes:

- model-specific loading and visual feature extraction in `helpers/classifier_helpers.py` and related helpers;
- dataset construction and edit/locality sample preparation in `helpers/data_helpers.py`;
- the editing and evaluation flow in `edit.py`;
- masked visual-feature supervision and answer-token teacher-forcing loss;
- optional token-locality KL regularization;
- context-subspace projection / low-rank constraints for the edited weights;
- experiment configuration in `config/`.

These bullets describe the current code organization and implemented components. The precise method definition, objective, assumptions, and reported results should be taken from the accompanying research write-up and experiments, not inferred from this README alone.

## Repository layout

- `main.py`: experiment entry point and configuration loading.
- `edit.py`: AKE editing and evaluation flow.
- `helpers/`: model loading, data processing, feature extraction, context estimation, and editing helpers.
- `config/`: model-specific experiment configurations.
- `dataset/`: dataset metadata and image/mask assets.

## Run

Run commands from this branch's repository root:

```bash
python main.py --config config/llava.yaml
python main.py --config config/blip2.yaml
python main.py --config config/qwenvl.yaml
```

Check each YAML file for the selected model checkpoint, dataset, image/mask directories, and output directory. The configuration files contain experiment settings; do not change their values merely to make a local environment work. Prefer a separate local configuration when adapting paths or machine-specific settings.

## Data and external assets

The branch may rely on image corpora, pretrained model weights, generated ZM-K/context caches, and experiment outputs that are not all distributed with the source code. Keep the original dataset files, images, masks, archives, checkpoints, and results. They are research assets, not disposable cache.

## Relationship to the other branches

- `main` is the EasyEdit-based reproduction and benchmark track. It is not the AKE method implementation.
- `visedit` contains experiments based on the published VisEdit method by other authors. It is a separate third-party-method track and may contain project-specific modifications.
- This `akedit` branch is the implementation of our own AKE method.

## Attribution

AKE is the method developed in this project. The model backbones and supporting libraries used by the implementation (including BLIP-2, LLaVA, Qwen-VL utilities, PyTorch, and Transformers) are third-party components and should be acknowledged according to their respective licenses and citation instructions. This branch does not claim ownership of those pretrained models or libraries.

No external paper is cited here as the source of the AKE method. When the AKE method is published or documented in a paper, add its canonical paper citation and DOI/arXiv link here.

## Reproducibility and scope

Use a dedicated environment for each model family where necessary. Dependencies and model-loading interfaces should be verified in the target environment before a full run. Repository maintenance should not change the AKE model structure, loss definitions, optimization logic, data selection, or experiment defaults.
