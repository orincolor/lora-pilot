#!/usr/bin/env bash
set -euo pipefail

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

python -m venv /opt/venvs/invoke
/opt/venvs/invoke/bin/pip install --upgrade pip setuptools wheel

PIP_CONSTRAINT= /opt/venvs/invoke/bin/pip install --no-cache-dir \
  --index-url "${INVOKE_TORCH_INDEX_URL}" \
  torch==${INVOKE_TORCH_VERSION} \
  torchvision==${INVOKE_TORCHVISION_VERSION} \
  torchaudio==${INVOKE_TORCHAUDIO_VERSION}

PIP_CONSTRAINT= /opt/venvs/invoke/bin/pip install \
  -c /opt/pilot/config/invoke-constraints.txt \
  "invokeai==${INVOKEAI_VERSION}"

PIP_CONSTRAINT= /opt/venvs/invoke/bin/pip install --no-cache-dir \
  -c /opt/pilot/config/invoke-constraints.txt \
  "huggingface_hub[hf_transfer]==${INVOKE_HF_HUB_VERSION}"

PIP_CONSTRAINT= /opt/venvs/invoke/bin/pip install --no-cache-dir \
  -c /opt/pilot/config/invoke-constraints.txt \
  "transformers==${INVOKE_TRANSFORMERS_VERSION}" \
  "accelerate==${INVOKE_ACCELERATE_VERSION}" \
  "peft==${PEFT_VERSION}" \
  "numpy<2" \
  "pillow<11"
