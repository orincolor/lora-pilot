#!/usr/bin/env bash
set -euo pipefail

add-apt-repository -y ppa:deadsnakes/ppa
apt-get update
apt-get install -y --no-install-recommends \
  python3.11 \
  python3.11-venv \
  python3.11-distutils \
  python3.11-tk \
  python3.11-dev
rm -rf /var/lib/apt/lists/*

curl -sS https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
python3.11 /tmp/get-pip.py
rm -f /tmp/get-pip.py

update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

mkdir -p \
  /workspace \
  /opt/pilot \
  /opt/pilot/repos \
  /opt/venvs \
  /opt/pilot/config \
  /workspace/home/root \
  /workspace/home/root/.cache/pip \
  /workspace/home/root/.fonts
