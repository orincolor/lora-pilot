#!/usr/bin/env bash
set -euo pipefail

: "${JUPYTERLAB_VERSION:?JUPYTERLAB_VERSION is required}"
: "${IPYWIDGETS_VERSION:?IPYWIDGETS_VERSION is required}"

python -m venv /opt/venvs/tools
/opt/venvs/tools/bin/pip install --upgrade pip setuptools wheel
/opt/venvs/tools/bin/pip install --no-cache-dir \
  "jupyterlab==${JUPYTERLAB_VERSION}" \
  "ipywidgets==${IPYWIDGETS_VERSION}"

python -m venv /opt/venvs/core
/opt/venvs/core/bin/pip install --upgrade pip "setuptools<81.0" wheel
