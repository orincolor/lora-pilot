#!/usr/bin/env bash
set -euo pipefail

: "${CODE_SERVER_VERSION:?CODE_SERVER_VERSION is required}"

curl -fsSL https://code-server.dev/install.sh | VERSION="${CODE_SERVER_VERSION}" sh
