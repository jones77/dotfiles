#!/usr/bin/env bash

extra_dir="$(base64 -d 'L29wdC9iYg==')"
export PATH="$extra_dir/bin:$PATH"

# FIXME: Move to configure_env.sh

# vim w3m plugin needs w3m
sudo yum install w3m

# tmux-cpu-info.py needs psutil
sudo "apt-get install python3.7-psutil"

# Fix timezone
sudo timedatectl set-timezone America/New_York

yum install epel-release
