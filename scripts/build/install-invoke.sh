#!/usr/bin/env bash
set -euo pipefail

. /opt/pilot/build/lib/python_venv.sh

if [[ "${INSTALL_INVOKE:-1}" != "1" ]]; then
  echo "Skipping InvokeAI install (INSTALL_INVOKE=${INSTALL_INVOKE:-0})"
  exit 0
fi

: "${INVOKE_TORCH_INDEX_URL:?INVOKE_TORCH_INDEX_URL is required}"
: "${INVOKE_TORCH_VERSION:?INVOKE_TORCH_VERSION is required}"
: "${INVOKE_TORCHVISION_VERSION:?INVOKE_TORCHVISION_VERSION is required}"
: "${INVOKE_TORCHAUDIO_VERSION:?INVOKE_TORCHAUDIO_VERSION is required}"
: "${INVOKEAI_VERSION:?INVOKEAI_VERSION is required}"
: "${INVOKE_HF_HUB_VERSION:?INVOKE_HF_HUB_VERSION is required}"
: "${INVOKE_TRANSFORMERS_VERSION:?INVOKE_TRANSFORMERS_VERSION is required}"
: "${INVOKE_ACCELERATE_VERSION:?INVOKE_ACCELERATE_VERSION is required}"
: "${PEFT_VERSION:?PEFT_VERSION is required}"

create_venv /opt/venvs/invoke setuptools wheel

pip_install_unconstrained_in_venv /opt/venvs/invoke \
  --index-url "${INVOKE_TORCH_INDEX_URL}" \
  torch==${INVOKE_TORCH_VERSION} \
  torchvision==${INVOKE_TORCHVISION_VERSION} \
  torchaudio==${INVOKE_TORCHAUDIO_VERSION}

pip_install_unconstrained_in_venv /opt/venvs/invoke \
  -c /opt/pilot/config/invoke-constraints.txt \
  "invokeai==${INVOKEAI_VERSION}"

pip_install_unconstrained_in_venv /opt/venvs/invoke \
  -c /opt/pilot/config/invoke-constraints.txt \
  "huggingface_hub[hf_transfer]==${INVOKE_HF_HUB_VERSION}"

pip_install_unconstrained_in_venv /opt/venvs/invoke \
  -c /opt/pilot/config/invoke-constraints.txt \
  "transformers==${INVOKE_TRANSFORMERS_VERSION}" \
  "accelerate==${INVOKE_ACCELERATE_VERSION}" \
  "peft==${PEFT_VERSION}" \
  "numpy<2" \
  "pillow<11"
