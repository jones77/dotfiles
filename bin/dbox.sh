#!/usr/bin/env bash

set -o errexit

__machine="$(uname -m)"
__install_dir="$HOME"
__dropboxd="$HOME/.dropbox-dist/dropboxd"

if [[ ! -f "$__dropboxd" ]]
then
    mkdir -p "$__install_dir"
    cd "$__install_dir"
    echo "Installing dropbox to $__install_dir"
    if [[ $__machine == x86_64 ]]
    then
        wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xvzf -
    else
        # FIXME: Untested
        wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xvzf -
    fi
fi
printf "Running $(ls "$__dropboxd")\n"
"$__dropboxd"
