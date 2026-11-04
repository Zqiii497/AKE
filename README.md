# VisEdit-Based Experiments (Third-Party Method)

This branch contains experiments based on **VisEdit**, a visual-language-model editing method proposed by Qizhou Chen, Taolin Zhang, Chengyu Wang, Xiaofeng He, Dakan Wang, and Tingting Liu. **VisEdit is not our original method.** This branch is derived from the authors' public implementation and may include local changes made for our own experiments, model support, environment, or data setup.

Please acknowledge and cite the original VisEdit work when using this branch. Do not present the original VisEdit method as an original contribution of this project.

## Original work and source repository

- **Original code:** [qizhou000/VisEdit](https://github.com/qizhou000/VisEdit)
- **Paper:** Qizhou Chen, Taolin Zhang, Chengyu Wang, Xiaofeng He, Dakan Wang, and Tingting Liu. “Attribution Analysis Meets Model Editing: Advancing Knowledge Correction in Vision Language Models with VisEdit.” *Proceedings of the AAAI Conference on Artificial Intelligence*, 39(2), 2168–2176, 2025.
- **DOI:** [10.1609/aaai.v39i2.32215](https://doi.org/10.1609/aaai.v39i2.32215)
- **AAAI paper page:** [https://ojs.aaai.org/index.php/AAAI/article/view/32215](https://ojs.aaai.org/index.php/AAAI/article/view/32215)

### Citation

```bibtex
@inproceedings{chen2025visedit,
  author    = {Chen, Qizhou and Zhang, Taolin and Wang, Chengyu and He, Xiaofeng and Wang, Dakan and Liu, Tingting},
  title     = {Attribution Analysis Meets Model Editing: Advancing Knowledge Correction in Vision Language Models with VisEdit},
  booktitle = {Proceedings of the AAAI Conference on Artificial Intelligence},
  volume    = {39},
  number    = {2},
  pages     = {2168--2176},
  year      = {2025},
  doi       = {10.1609/aaai.v39i2.32215}
}
```

## What this branch contains

This branch retains the VisEdit/VEAD experiment structure, including:

- `vead_train.py` and `vead_test.py`: VEAD training and evaluation entry points.
- `editor/vllm_editors/vead/`: VEAD editor and adaptor implementation.
- `editor/vllms_for_edit/`: visual-language-model wrappers.
- `dataset/`: dataset implementations and AKE-compatible dataset adapters.
- `evaluation/`: evaluation and metric aggregation.
- `p_track/`: representation/contribution tracking utilities.
- `configs/`: model and editor configurations.

The branch name and local project name do not change the provenance of the VisEdit method: the underlying method originates from the cited paper and upstream repository.

## Local modifications

This repository's `visedit` branch is an experimental derivative, not a pristine mirror of the upstream repository. It may contain project-specific changes. The exact set of differences should be established by comparing this branch with the relevant upstream commit/tag; do not assume that every local file is identical to the authors' release.

For research reporting, distinguish:
1. the method and components inherited from the original VisEdit work;
2. modifications made in this project;
3. additional baselines, models, datasets, or evaluation settings used in our experiments.

When describing a modification as a contribution, document the exact changed component and its effect. Do not attribute project-specific modifications to the original VisEdit authors.

## Environment, models, and data

Use a dedicated Python environment for this branch. Install dependencies from `requirements.txt` and select a PyTorch build compatible with the host CUDA runtime. The full environment has not been validated end-to-end across all model families.

The Qwen3-VL wrapper requires Transformers >= 4.57.0. Review `env.sh` before running it because it installs packages and downloads large datasets and model checkpoints. Training commands in `run.sh` expect prepared datasets under `data/`; some data assets are not tracked in this repository.

Keep original datasets, images, masks, archives, model checkpoints, and experiment outputs. They are research assets, not disposable cache.

## Relationship to the other branches

- `main`: EasyEdit-based reproduction and benchmark experiments; cite EasyEdit and the relevant multimodal editing work.
- `akedit`: our own AKE method implementation; it is separate from VisEdit.
- `visedit`: experiments based on the third-party VisEdit method described above.

## Reproducibility

This branch has received repository maintenance and local experiment adjustments, but no claim is made here that every upstream experiment has been exactly reproduced. Record the upstream commit, local patch set, configuration, model checkpoint, dataset version, random seed, and package versions for each reported result.
