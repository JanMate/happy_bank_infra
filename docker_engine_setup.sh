#!/bin/bash

set -euxo pipefail

echo "Init starting..."
sudo apt-get upgrade -y
sudo apt-get update || echo "apt-get update failed. Skipping..."
sudo apt-get install -y ca-certificates \
                     curl \
                     gnupg \
                     lsb-release
echo "Init finished..."

echo "Docker install starting..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update || echo "apt-get update failed. Skipping..."
sudo apt-get install -y docker-ce \
                        docker-ce-cli \
                        containerd.io \
                        docker-compose-plugin
apt-cache madison docker-ce

VERSION_STRING="5:18.09.9~3-0~ubuntu-bionic"
sudo apt-get install -y docker-ce="${VERSION_STRING}" \
                        docker-ce-cli="${VERSION_STRING}" \
                        containerd.io \
                        docker-compose-plugin

sudo docker run hello-world
echo "Docker install finished..."

echo "Docker post-install starting..."
sudo groupadd docker || echo "'docker' group already exists. Skipping..."
sudo usermod -aG docker "${USER}"

echo "Docker post-install finished..."

echo "Now, log out the shell and log in again. Then, run 'newgrp docker'. \
After this, 'docker run hello-world:latest' should run properly."
