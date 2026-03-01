#!/bin/bash
apt update -y

curl -fsSL https://get.docker.com -o install-docker.sh
sh install-docker.sh --dry-run
sh install-docker.sh

usermod -aG docker ubuntu

git clone https://github.com/eazytrainingfr/jenkins-training.git
cd jenkins-training
docker compose up -d