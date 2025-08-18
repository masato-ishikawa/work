#!/bin/bash

packages=(
  kubernetes-cli
  fzf
  ghq
  mariadb-connector-c
  podman
  watch
  microk8s
  pyenv
  helm
  htop
  fish
  k9s
  fluxcd/tap/flux
  firebase-cli
  font-hack-nerd-font
  multipass
#   raycast
)

brew update

for pkg in "${packages[@]}"; do
  brew install "$pkg"
done
