#!/usr/bin/env bash
set -euo pipefail

if [[ "${INSTALL_COPILOT_CLI:-1}" != "1" ]]; then
  echo "Skipping Copilot CLI install (INSTALL_COPILOT_CLI=${INSTALL_COPILOT_CLI:-0})"
  exit 0
fi

if [[ -n "${COPILOT_CLI_VERSION:-}" ]]; then
  VERSION="${COPILOT_CLI_VERSION}" PREFIX="/usr/local" bash -lc 'curl -fsSL https://gh.io/copilot-install | bash'
else
  PREFIX="/usr/local" bash -lc 'curl -fsSL https://gh.io/copilot-install | bash'
fi

command -v copilot
copilot --version || true
