#!/usr/bin/env bash

# TODO: Move to packages.sh

# vim w3m plugin needs w3m
sudo yum install w3m

# tmux-cpu-info.py needs psutil
sudo /opt/bb/bin/apt-get install python3.7-psutil

# Fix timezone
sudo timedatectl set-timezone America/New_York
