#!/usr/bin/env bash
set -euo pipefail

. /opt/pilot/build/lib/python_venv.sh

if [[ "${INSTALL_AI_TOOLKIT:-1}" != "1" ]]; then
  echo "Skipping AI Toolkit install (INSTALL_AI_TOOLKIT=${INSTALL_AI_TOOLKIT:-0})"
  exit 0
fi

if [[ "${INSTALL_INVOKE:-1}" != "1" ]]; then
  echo "Skipping AI Toolkit install because InvokeAI venv is disabled"
  exit 0
fi

: "${AI_TOOLKIT_REF:?AI_TOOLKIT_REF is required}"
: "${AI_TOOLKIT_DIFFUSERS_VERSION:?AI_TOOLKIT_DIFFUSERS_VERSION is required}"
: "${PEFT_VERSION:?PEFT_VERSION is required}"
: "${BUILDPLATFORM:=}"
: "${TARGETPLATFORM:=}"

/opt/pilot/build/lib/git_checkout.sh \
  https://github.com/ostris/ai-toolkit.git \
  /opt/pilot/repos/ai-toolkit \
  "${AI_TOOLKIT_REF}"

/opt/pilot/build/patches/patch-ai-toolkit.sh /opt/pilot/repos/ai-toolkit "${INSTALL_AI_TOOLKIT_UI:-1}"

rm -rf /opt/pilot/repos/ai-toolkit/datasets /opt/pilot/repos/ai-toolkit/output /opt/pilot/repos/ai-toolkit/models
ln -s /workspace/datasets /opt/pilot/repos/ai-toolkit/datasets
ln -s /workspace/outputs/ai-toolkit /opt/pilot/repos/ai-toolkit/output
ln -s /workspace/models /opt/pilot/repos/ai-toolkit/models

grep -v -E '^(torch|torchvision|torchaudio|numpy|pillow|Pillow|diffusers|gradio|gradio-client)([<>= ]|$)|diffusers' \
  /opt/pilot/repos/ai-toolkit/requirements.txt > /tmp/ai-toolkit-req.txt
pip_install_unconstrained_in_venv /opt/venvs/invoke \
  -c /opt/pilot/config/invoke-constraints.txt \
  -r /tmp/ai-toolkit-req.txt
rm -f /tmp/ai-toolkit-req.txt

pip_install_unconstrained_in_venv /opt/venvs/invoke \
  -c /opt/pilot/config/invoke-constraints.txt \
  "diffusers==${AI_TOOLKIT_DIFFUSERS_VERSION}" \
  "numpy<2" \
  "pillow<11" \
  oyaml \
  "opencv-python-headless<4.13" \
  "albucore==0.0.16" \
  "albumentations==1.4.15" \
  lpips \
  "optimum[quanto]" \
  "torchao==0.10.0" \
  "lycoris-lora==1.8.3" \
  "peft==${PEFT_VERSION}" \
  timm \
  open-clip-torch \
  k-diffusion \
  "controlnet_aux==0.0.10"

/opt/venvs/invoke/bin/python -c 'import peft; import timm; import open_clip; import lycoris; import lycoris.kohya; import torchao; import optimum.quanto'

if [[ "${INSTALL_AI_TOOLKIT_UI:-1}" == "1" ]]; then
  cd /opt/pilot/repos/ai-toolkit/ui
  npm install
  DATABASE_URL=file:/tmp/aitk_db.db npx prisma generate
  if [[ -z "${BUILDPLATFORM}" || -z "${TARGETPLATFORM}" || "${BUILDPLATFORM}" == "${TARGETPLATFORM}" ]]; then
    npm run build
  else
    echo "Skipping AI Toolkit UI build during cross-platform build (${BUILDPLATFORM} -> ${TARGETPLATFORM}); runtime will build missing assets on first start."
  fi
  npm cache clean --force
fi
