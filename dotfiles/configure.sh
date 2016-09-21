#!/usr/bin/env bash

set -e  # stop on first error

if [[ ! -d "~/.vim/bundle/Vundle.vim" ]]
then
    git clone https://github.com/VundleVim/Vundle.vim.git \
        ~/.vim/bundle/Vundle.vim
fi

ls -1ad .* | tail -n+3 | while read dotfile
do
    fromfile="`pwd`/$dotfile"
    tofile="$HOME/$dotfile"

    if [[ ! -e "$tofile" ]]
    then
        # only need to link it once
        ln -s "$fromfile" "$tofile"
    fi
    ls -l "$tofile"
done
