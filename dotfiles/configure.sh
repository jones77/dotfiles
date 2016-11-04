#!/usr/bin/env bash

set -e  # stop on first error

if [[ ! -d ~/.vim/bundle/Vundle.vim ]]
then
    git clone https://github.com/VundleVim/Vundle.vim.git \
        ~/.vim/bundle/Vundle.vim
fi

for dotfile in .profile.ext .tmux.conf .vimrc .Xresources
do
    fromfile="`pwd`/$dotfile"
    tofile="$HOME/$dotfile"

    if [[ -e "$tofile" ]]
    then
        mkdir -p moved
        file_basename=`basename "$tofile"`
        timestamp=`date +%Y%m%d%H%M%S`
        mv -f "$tofile" "moved/$file_basename.$timestamp"
    fi
    ln -s "$fromfile" "$tofile"
    ls -l "$tofile"
done
