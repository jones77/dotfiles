#!/usr/bin/env bash

set -e  # stop on first error

if [[ ! -d ~/.vim/bundle/Vundle.vim ]]
then
    git clone https://github.com/VundleVim/Vundle.vim.git \
        ~/.vim/bundle/Vundle.vim
fi

for dotfile in ./dotfiles/*
do
    from="$(pwd)/${dotfile}"
    d=$(basename "$from")
    to="${HOME}/.${d}"

    if [[ -L "$to" ]]
    then
        echo "Removing symbolic link:"
        echo "  " $(ls -l "$to")

        rm "$to"
    elif [[ -e "$to" ]]
    then
	backups="${HOME}/backups"
        mv -f "Backing up $to => ${backups}/$file_basename.$timestamp"

        [[ -d ${backups} ]] || mkdir -p ${backups}
        mv -f "$to" "${backups}/$file_basename.$timestamp"
        file_basename=$(basename "$to")
        timestamp=$(date +%Y%m%d%H%M%S)
    fi
    echo "Creating symbolic link:"

    ln -s "$from" "$to"
    echo "  " $(ls -l "$to")
done
