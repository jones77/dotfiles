#!/usr/bin/env bash

set -e  # stop on first error

if [[ ! -d ~/.vim/bundle/Vundle.vim ]]
then
    git clone https://github.com/VundleVim/Vundle.vim.git \
        ~/.vim/bundle/Vundle.vim
fi

for dir in "bin" "dotfiles"
do
    if [[ "$dir" == "dotfiles" ]]
    then
        to_dir="$HOME"
    else
        to_dir="$HOME/$dir"
    fi

    for file in $(ls -A ${dir})
    do
	if [[ "$file" =~ '.swp'$ ]]
        then
            echo "Skipping $file"
            continue
        fi

        from="$(pwd)/$dir/$file"
        to="$to_dir/$file"

        if [[ -L "$to" ]]
        then
            echo "Removing symbolic link:"
            echo "  " $(ls -l "$to")

            rm "$to"
        elif [[ -e "$to" ]]
        then
            backups="${HOME}/backups"
            timestamp=$(date +%Y%m%d%H%M%S)
            echo "Backing up $to => ${backups}/$file.$timestamp"

            [[ -d "$backups" ]] || mkdir -p "$backups"
            mv -f "$to" "$backups/$file.$timestamp"
        fi
        echo "Creating symbolic link:"

        ln -s "$from" "$to"
        echo "  " $(ls -l "$to")
    done
done
