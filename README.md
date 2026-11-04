# Multimodal Knowledge Editing: EasyEdit Reproduction and Benchmark Experiments

This repository's `main` branch is the **EasyEdit-based reproduction and benchmarking track** of this project. It is intended to reproduce and run multimodal knowledge-editing experiments using the EasyEdit framework and related multimodal editing setup. It is **not** the original EasyEdit repository, and it is **not** the implementation of the project's own AKE method.

## How this repository is organized

This GitHub repository contains three research tracks that must be distinguished:

| Branch | Role | Method provenance |
|---|---|---|
| `main` | EasyEdit-based reproduction and benchmark experiments for multimodal knowledge editing | Based on the upstream EasyEdit framework and its multimodal editing implementation; this branch contains project-specific reproduction/configuration work |
| `akedit` | Implementation of **our own AKE method** | Method developed in this project; do not attribute it to EasyEdit or VisEdit |
| `visedit` | Experiments based on the published VisEdit method | Derived from the original VisEdit project and may contain local modifications for our experiments |

The branches serve different research purposes. Their implementations, experimental settings, and citations are not interchangeable.

## Main branch: EasyEdit reproduction

The `easyeditor/` directory contains the EasyEdit-based editing framework and multimodal editing components. The project-specific entry point is `multimodal_edit.py`, with configuration files under `hparams/` and setup/download helpers in `run.sh`.

This branch is used to reproduce and benchmark selected multimodal editing methods and model combinations in a controlled experimental setup. Repository-specific scripts, configuration changes, model-path adjustments, and dependency pins should be understood as part of this reproduction project, rather than as changes to the official EasyEdit release.

### Upstream projects and papers

- **EasyEdit framework:** [Official repository](https://github.com/zjunlp/EasyEdit)  
  Wang et al., “EasyEdit: An Easy-to-use Knowledge Editing Framework for Large Language Models,” ACL 2024 System Demonstrations. [Paper](https://aclanthology.org/2024.acl-demos.9/).
- **Multimodal editing benchmark/background:** Cheng et al., “Can We Edit Multimodal Large Language Models?”, EMNLP 2023. [Paper](https://aclanthology.org/2023.emnlp-main.856/). The EasyEdit project provides its multimodal editor in connection with this line of work; see the [official multimodal editing example](https://github.com/zjunlp/EasyEdit/blob/main/examples/MultimodalEdit.md).

Please cite the relevant upstream framework and research papers when using or building on this branch. Also cite any individual editing method or dataset paper corresponding to the experiment being reported.

## Other research tracks

- **`akedit`:** our own AKE method. See the [AKE method README](https://github.com/Zqiii497/AKE/tree/akedit). This is a separate method implementation, not an EasyEdit baseline.
- **`visedit`:** experiments based on the third-party VisEdit method. See the [VisEdit experiment README](https://github.com/Zqiii497/AKE/tree/visedit) and the original [VisEdit repository](https://github.com/qizhou000/VisEdit).

## Environment and reproducibility

Use an isolated environment for each model family where necessary. The top-level requirements currently pin Transformers 4.57.6 and Tokenizers 0.22.1 to meet the Qwen3-VL Transformers requirement, but this combination has not been validated end-to-end across every model family or Python/CUDA platform. In particular, nested model components may have conflicting dependency requirements.

Install the top-level dependencies:

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

The setup helper is opt-in; running it without arguments only prints help:

```bash
bash run.sh --help
```

Review the selected model configuration, dataset paths, model licenses, credentials, and storage requirements before downloading or launching experiments. The presence of a command or configuration in this repository does not imply that the corresponding experiment has been successfully reproduced.

## Scope and attribution

- This branch is the project's EasyEdit-based reproduction/benchmark track; it should not be described as the official EasyEdit project.
- The project's own AKE method is maintained separately on `akedit`.
- VisEdit-derived experiments are maintained separately on `visedit` and must acknowledge the original VisEdit authors and source repository.
- Preserve upstream licenses, copyright notices, and attribution when reusing or modifying third-party code.
- Report local modifications and experimental settings accurately. Do not claim full reproduction or end-to-end validation unless it has been performed.
