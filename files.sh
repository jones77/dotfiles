#!/usr/bin/env bash
#
# Create symbolic links for the dotfiles in ./dotfiles/
#
source dotfiles/shelllib.sh
# VUNDLE
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]
then
    git clone https://github.com/VundleVim/Vundle.vim.git \
              ~/.vim/bundle/Vundle.vim

    git clone https://github.com/powerline/fonts.git ~/github/fonts
    ~/github/fonts/install.sh
fi
# DOTFILES
for dir in "bin" "dotfiles"
do
    if [[ "$dir" == "dotfiles" ]]
    then
        to_dir_prefix="$HOME/."  # Implicit $dir/file ~/.file rename
    else
        to_dir_prefix="$HOME/$dir/"
        if [[ ! -e "$to_dir_prefix" ]]
        then
            echo "Creating $to_dir_prefix"
            mkdir -p "$to_dir_prefix"
        fi
    fi

    for filename in $(ls -A "$dir")
    do
	if [[ "$filename" =~ '.swp'$ ]]
        then
            echo "Skipping VIM swapfile: $filename"
            continue
            # FIXME: Use .gitignore to ignore more file types
        fi

        from="$(pwd)/${dir}/${filename}"
        to="${to_dir_prefix}${filename}"

        # FIXME: the symbolic links git bash on Windows uses return false for
        # test -L so we have to windowshackhack some tests in the following.
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
            # Ignore directories though. 
            [[ ! -d "$to" ]] && mv -f "$to" "$backups/$file.$timestamp"
            # ^^ windowshackhack
        fi

        [[ ! -d "$to" ]] && ln -s "$from" "$to"
        # ^^ windowshackhack
        ls -l "$to"
    done
done
vim +PluginInstall +qall  # Can only install plugins after .vimrc is updated
# APPEND TO DOT PROFILE
[[ -f "$HOME/.bash_profile" ]] && profile_file="$HOME/.bash_profile" \
                               || profile_file="$HOME/.profile"
declare -r spg="source ~/.profile.general"
function add_spg {
    echo "$spg" >> "$profile_file"
    echo "$spg added to $profile_file"
}
grep '^source.*\.profile\.general$' "$profile_file" 1>/dev/null 2>&1 || add_spg
ce Yellow "Source it: $( ce Green source $profile_file )"
# END
