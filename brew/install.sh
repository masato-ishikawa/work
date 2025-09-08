#!/bin/bash

packages=(
fish
font-hack-nerd-font
ghq
fzf
watch
htop
gh
ripgrep
yq
jq
wget
k9s
kubectx
raycast
helm
fluxcd/tap/flux
controlplaneio-fluxcd/tap/flux-operator-mcp
kustomize
pyenv
pipenv
tfenv
direnv
goenv
tofuenv
kubernetes-cli
azure-cli
awscli
gcloud-cli
# # private
# podman
# microk8s
# multipass
# firebase-cli
# mariadb-connector-c
)

brew update

for pkg in "${packages[@]}"; do
  brew install "$pkg"
done
