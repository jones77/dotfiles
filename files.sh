#!/usr/bin/env bash
#
# Creates symbolic links from $HOME or $HOME/<dir> to ./dotfiles or ./<dir>.
#
# Be careful, 'cos it's dotfiles:
set -e
# Error handling returns you to where you were on error.
declare -r original_dir=$(pwd)
function cdback {
    cd "$original_dir"
}
trap cdback ERR
# But we move to the scripts dir until we get to the end of the program.
cd $(dirname "${BASH_SOURCE[0]}")  # Go to ./configure.sh's directory
# Install Vundle if necessary
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]
then
    git clone https://github.com/VundleVim/Vundle.vim.git \
              ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
fi

for dir in "bin" "dotfiles"
do
    if [[ "$dir" == "dotfiles" ]]
    then  # $HOME's dotfiles
        to_dir="$HOME"
    else  # per dir installs
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
            echo "Skipping VIM swapfile: $file"
            continue
            # FIXME: Use .gitignore to ignore more file types
        fi

        from="$(pwd)/$dir/$file"
        to="$to_dir/$file"

        if [[ -L "$to" ]]
        then
            rm "$to"  # Remove symbolic links
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

declare -r spg="source $HOME/.profile.general"
# add "source .profile.general" if it doesn't exist
grep "$spg" ~/.profile 2>/dev/null || echo "$spg" >> ~/.profile
eval $spg  # So fresh and so clean.  (ie: source .profile.general)
cdback
