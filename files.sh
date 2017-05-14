#!/usr/bin/env bash
#
# Create symbolic links for the dotfiles in ./dotfiles/
#
# VUNDLE
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]
then
    git clone https://github.com/VundleVim/Vundle.vim.git \
              ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall

    git clone https://github.com/powerline/fonts.git ~/github/fonts
    ~/github/fonts/install.sh
fi
# DOTFILES
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
            echo "Skipping VIM swapfile: $file"
            continue
            # FIXME: Use .gitignore to ignore more file types
        fi

        from="$(pwd)/$dir/$file"
        to="$to_dir/$file"

        if [[ -L "$to" ]]
        then
            # Remove symbolic links ...
            rm "$to"
        elif [[ -e "$to" ]]
        then
            # ... backup real files.
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
# APPEND TO DOT PROFILE
[[ -f "$HOME/.bash_profile" ]] && profile_file="$HOME/.bash_profile" \
                               || profile_file="$HOME/.profile"
declare -r spg="source ~/.profile.general"
function add_spg {
    echo "$spg" >> "$profile_file"
    echo "$spg added to $profile_file"
}
grep '^source.*\.profile\.general$' "$profile_file" 1>/dev/null 2>&1 || add_spg
eval $spg
# END
