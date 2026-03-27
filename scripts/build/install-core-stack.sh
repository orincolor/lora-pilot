#!/usr/bin/env bash
set -euo pipefail

: "${TORCH_VERSION:?TORCH_VERSION is required}"
: "${TORCHVISION_VERSION:?TORCHVISION_VERSION is required}"
: "${TORCHAUDIO_VERSION:?TORCHAUDIO_VERSION is required}"
: "${TORCH_INDEX_URL:?TORCH_INDEX_URL is required}"
: "${XFORMERS_VERSION:?XFORMERS_VERSION is required}"
: "${CORE_DIFFUSERS_VERSION:?CORE_DIFFUSERS_VERSION is required}"
: "${TRANSFORMERS_VERSION:?TRANSFORMERS_VERSION is required}"
: "${PEFT_VERSION:?PEFT_VERSION is required}"

if [[ "${INSTALL_GPU_STACK:-1}" == "1" ]]; then
  /opt/venvs/core/bin/pip install --no-cache-dir \
    "torch==${TORCH_VERSION}" \
    "torchvision==${TORCHVISION_VERSION}" \
    "torchaudio==${TORCHAUDIO_VERSION}" \
    --index-url "${TORCH_INDEX_URL}"

  /opt/venvs/core/bin/pip install --no-cache-dir \
    -c /opt/pilot/config/core-constraints.txt \
    "xformers==${XFORMERS_VERSION}" \
    bitsandbytes==0.46.0 \
    toml \
    accelerate \
    "diffusers==${CORE_DIFFUSERS_VERSION}" \
    "transformers==${TRANSFORMERS_VERSION}" \
    "peft==${PEFT_VERSION}" \
    safetensors \
    torchsde \
    "numpy<2" \
    "pillow<12" \
    tqdm \
    psutil
else
  echo "Skipping GPU stack install (INSTALL_GPU_STACK=${INSTALL_GPU_STACK:-0})"
fi

/opt/venvs/core/bin/pip install --no-cache-dir \
  -c /opt/pilot/config/core-constraints.txt \
  "huggingface_hub[hf_transfer,hf_xet]"

/opt/venvs/core/bin/pip install --no-cache-dir \
  -c /opt/pilot/config/core-constraints.txt \
  fastapi \
  "uvicorn[standard]" \
  pydantic \
  python-multipart \
  flask \
  flask-cors \
  requests \
  python-dotenv \
  python-socketio \
  websockets \
  pillow \
  httpx
