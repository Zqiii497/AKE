#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ $# -eq 0 ]]; then
  cat <<'EOF'
Usage:
  bash run.sh <config.yaml> [main.py arguments...]

Examples:
  bash run.sh config/blip2.yaml
  bash run.sh config/llava.yaml
  bash run.sh config/qwenvl.yaml

Run from any working directory. Dataset and checkpoint paths are resolved
relative to this repository unless an absolute path is supplied in the YAML.
EOF
  exit 0
fi

CONFIG="$1"
shift
exec python main.py --config "$CONFIG" "$@"
