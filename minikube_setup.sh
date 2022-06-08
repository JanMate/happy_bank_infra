#!/bin/bash

set -euxo pipefail

echo "minikube install starting..."

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start
minikube status

echo "minikube install finished..."


echo "minikube autocompletion starting..."

sudo apt-get install bash-completion
source /etc/bash_completion
source <(minikube completion bash)

echo "minikube autocompletion finished..."
