#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: $0 [--recurse-submodules] <repo_url> <dest_dir> <ref>" >&2
  exit 2
}

recurse_submodules=0
if [[ "${1:-}" == "--recurse-submodules" ]]; then
  recurse_submodules=1
  shift
fi

[[ $# -eq 3 ]] || usage

repo_url="$1"
dest_dir="$2"
ref="$3"

[[ -n "${repo_url}" ]] || usage
[[ -n "${dest_dir}" ]] || usage
[[ -n "${ref}" ]] || usage

clone_args=(--depth 1)
if [[ "${recurse_submodules}" == "1" ]]; then
  clone_args+=(--recurse-submodules)
fi

if [[ ! -d "${dest_dir}/.git" ]]; then
  rm -rf "${dest_dir}"
  git clone "${clone_args[@]}" "${repo_url}" "${dest_dir}"
fi

if git -C "${dest_dir}" rev-parse -q --verify "${ref}^{commit}" >/dev/null 2>&1; then
  git -C "${dest_dir}" checkout "${ref}"
else
  git -C "${dest_dir}" fetch --depth 1 origin "${ref}"
  git -C "${dest_dir}" checkout FETCH_HEAD
fi

if [[ "${recurse_submodules}" == "1" ]]; then
  git -C "${dest_dir}" submodule update --init --recursive
fi
