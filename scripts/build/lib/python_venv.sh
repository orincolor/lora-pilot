#!/usr/bin/env bash
set -euo pipefail

create_venv() {
  local venv_path="$1"
  shift

  python -m venv "${venv_path}"
  "${venv_path}/bin/pip" install --upgrade pip "$@"
}

pip_install_in_venv() {
  local venv_path="$1"
  shift

  "${venv_path}/bin/pip" install --no-cache-dir "$@"
}

pip_install_unconstrained_in_venv() {
  local venv_path="$1"
  shift

  PIP_CONSTRAINT= "${venv_path}/bin/pip" install --no-cache-dir "$@"
}
