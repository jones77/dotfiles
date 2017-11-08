#!/usr/bin/env bash

set -o errexit

# https://nixos.org/nix/manual/#chap-quick-start
nix-channel --update nixpkgs
nix-env -i \
    firefox \
    gcc \
    mopidy \
    mopidy-spotify \
    tmux \
    vim \
    xterm \
# env of nix-env -i
nix-env -u '*'
