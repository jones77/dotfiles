#!/usr/bin/env bash
#
# Create symbolic links for the dotfiles in ./dotfiles/
#
cd "$(dirname "${BASH_SOURCE[0]}")"  # Note: Always Be Local
source ./home/dotfiles/shelllib.sh

# TODO: status bar has dependency on python3.7-psutil
# TODO: Add options, eg disable installing vim plugins

# VUNDLE
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]
then
    git clone https://github.com/VundleVim/Vundle.vim.git \
              ~/.vim/bundle/Vundle.vim

    git clone https://github.com/powerline/fonts.git ~/src/github/fonts
    ~/src/github/fonts/install.sh

    git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git \
        ~/src/github/iTerm2-Color-Schemes.git
fi

# DOTFILES
for dir in home/*
do
    to_subdir=${dir#home/}
    ce Yellow "to_subdir=$to_subdir"
    case $to_subdir in
        dotfiles)
            to_dir="$HOME/."
            ;;
        *)
            to_dir="$HOME/$to_subdir"
            ;;
    esac

    ce Yellow "to_dir=$to_dir"
    if [[ ! -e "$to_dir" ]]
    then
        ce Yellow "Creating $to_dir"
        mkdir -p "$to_dir"
    fi

    for filename in "$dir"/*
    do
        if [[ $filename =~ .swp$ || $filename =~ ^Session.vim$ ]]
        then
            ce Red "Skipping VIM swapfile: $filename"
            continue
            # FIXME: Use .gitignore to ignore more file types
        fi

        from="$(pwd)/${filename}"
        to="${to_dir}/${filename##*/}"

        [[ -L "$to" ]] && rm "$to"  # Remove previous symbolic links.
        ln -s "$from" "$to"
        ls -l "$to"
    done
done

j18=$(echo -n 'ampvbmVzMThAYmxsb21iZXJnLm5ldA==' | base64 -d)
j77=$(echo -n 'amFtZXNAam9uZXM3Ny5jb21l' | base64 -d)
if [[ $(whoami) == jjones ]]
then
    git config --global http.sslVerify false
    git config --global user.name "James Jones"
    git config --global user.email "$j18"
    git config --global credential.helper 'cache --timeout 604800'
elif [[ $(whoami) == jones ]] || [[ $(whoami) == root ]]
then
    git config --global http.sslVerify true
    git config --global user.name "James Jones"
    git config --global user.email "$j77"
    git config --global credential.helper 'cache --timeout 604800'
fi
vim '+PluginInstall' +qall
# go
mkdir -p ~/go/bin
# https://nixos.org/nix/
# [[ -f '/home/jjones/.nix-profile/etc/profile.d/nix.sh' ]] \
#     || curl https://nixos.org/nix/install | sh
# APPEND TO DOT PROFILE
[[ -f "$HOME/.bash_profile" ]] && profile_file="$HOME/.bash_profile" \
                               || profile_file="$HOME/.profile"
declare -r spg="source ~/.profile.general"  # source profile general
function add_spg {
    echo "$spg" >> "$profile_file"
    ce Green "$spg added to $profile_file"
}
grep '^source.*\.profile\.general$' "$profile_file" 1>/dev/null 2>&1 || add_spg
go get -u github.com/nsf/gocode  # needed by completor
ce Yellow "Source it:"
ce Green "    source $profile_file"
# END
