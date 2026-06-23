#!/usr/bin/env bash
set -euo pipefail

# Usage: deploy.sh <ssh_user> <vm_ip> <image>
SSH_USER="$1"
VM_IP="$2"
IMAGE="$3"

ssh -o StrictHostKeyChecking=no ${SSH_USER}@${VM_IP} \
  "docker rm -f ci-cd-demo || true; docker pull ${IMAGE} || true; docker run -d --name ci-cd-demo -p 80:3000 ${IMAGE}"
