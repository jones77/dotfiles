#!/usr/bin/env bash
# Creates symbolic links from $HOME or $HOME/<dir> to ./dotfiles or ./<dir>.
#
set -e
# Go back to where we were on error.
original_dir=$(pwd)
function cd_back {
    cd "$original_dir"
}
trap cd_back ERR
# Go to ./configure.sh's directory.
script_dir=$(dirname "${BASH_SOURCE[0]}")
cd $script_dir
# Install Vundle if necessary.
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

        if [[ ! -e "$to_dir" ]]
        then
            echo "Creating $to_dir"
            mkdir -p "$to_dir"
        fi
    fi

    for file in $(ls -A "$dir")
    do
	if [[ "$file" =~ '.swp'$ ]]
        then
            # FIXME: Use .gitignore to ignore files.
            echo "Skipping $file"
            continue
        fi

        from="$(pwd)/$dir/$file"
        to="$to_dir/$file"

        if [[ -L "$to" ]]
        then
            rm "$to"  # Remove symbolic links.
        elif [[ -e "$to" ]]
        then
            backups="$HOME/backups"
            timestamp=$(date +%Y%m%d%H%M%S)
            echo "Backing up $to => $backups/$file.$timestamp"

            [[ -d "$backups" ]] || mkdir -p "$backups"
            mv -f "$to" "$backups/$file.$timestamp"
        fi
        ln -s "$from" "$to"
        echo $(ls -l "$to")
    done
done

source ~/bin/jjlib.sh  # In case any function/aliases changed.
