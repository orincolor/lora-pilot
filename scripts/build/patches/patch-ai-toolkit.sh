#!/usr/bin/env bash
set -euo pipefail

repo_dir="${1:-/opt/pilot/repos/ai-toolkit}"
ui_enabled="${2:-0}"

if [[ ! -d "${repo_dir}" ]]; then
  echo "AI Toolkit repo not found: ${repo_dir}" >&2
  exit 1
fi

diffusion_models_dir="${repo_dir}/extensions_built_in/diffusion_models"
init_file="${diffusion_models_dir}/__init__.py"

if [[ ! -d "${diffusion_models_dir}" ]]; then
  echo "AI Toolkit diffusion models dir not found: ${diffusion_models_dir}" >&2
  exit 1
fi

if [[ ! -f "${init_file}" ]]; then
  echo "AI Toolkit init file not found: ${init_file}" >&2
  exit 1
fi

rm -rf "${diffusion_models_dir}/ltx2"
sed -i '/\\.ltx2/d;/LTX2Model/d' "${init_file}"

if [[ "${ui_enabled}" != "1" ]]; then
  exit 0
fi

ui_dir="${repo_dir}/ui"
schema_file="${ui_dir}/prisma/schema.prisma"

if [[ ! -d "${ui_dir}" ]]; then
  echo "AI Toolkit UI dir not found: ${ui_dir}" >&2
  exit 1
fi

if [[ ! -f "${schema_file}" ]]; then
  echo "AI Toolkit Prisma schema not found: ${schema_file}" >&2
  exit 1
fi

sed -i 's|url      = \"file:../../aitk_db.db\"|url      = env(\"DATABASE_URL\")|' "${schema_file}"

matches_file="$(mktemp)"
if grep -R -l "/opt/pilot/repos/ai-toolkit/aitk_db.db" "${ui_dir}" > "${matches_file}"; then
  xargs -r sed -i 's|/opt/pilot/repos/ai-toolkit/aitk_db.db|/workspace/config/ai-toolkit/aitk_db.db|g' < "${matches_file}"
fi
rm -f "${matches_file}"
