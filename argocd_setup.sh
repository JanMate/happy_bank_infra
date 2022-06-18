#!/bin/bash

set -euxo pipefail

echo "argocd CLI install starting..."

sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd

echo "argocd CLI install finished..."
