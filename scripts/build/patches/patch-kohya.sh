#!/usr/bin/env bash
set -euo pipefail

repo_dir="${1:-/opt/pilot/repos/kohya_ss}"
target_file="${repo_dir}/requirements_pytorch_windows.txt"

if [[ ! -d "${repo_dir}" ]]; then
  echo "Kohya repo not found: ${repo_dir}" >&2
  exit 1
fi

if [[ ! -f "${target_file}" ]]; then
  echo "Kohya patch target not found: ${target_file}" >&2
  exit 1
fi

printf '# disabled by LoRA Pilot (use core venv torch)\n' > "${target_file}"
