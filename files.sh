#!/usr/bin/env bash
#
# Create symbolic links for the dotfiles in ./dotfiles/
#
cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd  # always be local
source ./dotfiles/shelllib.sh

is_windows_bash() {
    set -o errexit
    [[ $(uname -s) == MINGW6* ]]
}
longest_common_prefix () {
    # https://stackoverflow.com/a/6974992/469045
    local prefix= n
    ## Truncate the two strings to the minimum of their lengths
    if [[ ${#1} -gt ${#2} ]]
    then
        set -- "${1:0:${#2}}" "$2"
    else
        set -- "$1" "${2:0:${#1}}"
    fi

    ## Binary search for the first differing character, accumulating the common prefix
    while [[ ${#1} -gt 1 ]]
    do
        n=$(((${#1}+1)/2))
        if [[ ${1:0:$n} == ${2:0:$n} ]]
        then
            prefix=$prefix${1:0:$n}
            set -- "${1:$n}" "${2:$n}"
        else
            set -- "${1:0:$n}" "${2:0:$n}"
        fi
    done
    ## Add the one remaining character, if common
    if [[ $1 = $2 ]]
    then
        prefix=$prefix$1
    fi
    printf %s "$prefix"
}
win_check_link() {
    fsutil reparsepoint query "$1" > /dev/null
}
# Windows symbolic link code originally based on
# https://stackoverflow.com/a/25394801/469045
win_create_link() {
    # Usage: win_create_link target link (like ln has mv/cp semantics)
    # Note: Let's assume we're on the same drive so mklink ignores /c/ problems
    # FIXME: ^^ explain this in more depth
    common_root=$(longest_common_prefix "$1" "$2")
    cd $common_root  # cd $common_root and remove it, kloodge!
    # Note: we convert `/` to `\`. In this case it's necessary.
    ce Yellow "The common root was: $common_root"
    common_root=${common_root//\//\\}
    target=${1//\//\\}
    link=${2//\//\\}

    common_root_len=${#common_root}
    target_len=${#target}
    link_len=${#link}

    target_remaining_len=$((target_len - common_root_len))
    link_remaining_len=$((link_len - common_root_len))

    target=${target:$common_root_len:$target_remaining_len}
    link=${link:$common_root_len:$link_remaining_len}
    ce Cyan "The common root is: $common_root"
    echo
    ce Cyan "  mklink $link $target"
    # https://docs.microsoft.com/en-us/windows/device-security/security-policy-settings/create-symbolic-links
    # https://superuser.com/questions/124679/how-do-i-create-a-link-in-windows-7-home-premium-as-a-regular-user

    # $ fsutil behavior query SymlinkEvaluation
    # Local to local symbolic links are enabled.
    # Local to remote symbolic links are enabled.
    # Remote to local symbolic links are disabled.
    # Remote to remote symbolic links are disabled.

    # FIXME: Create symbolic links on Windows

    # Usage: mklink link target (mklink is backwards)
    cmd <<< "runas /user:administrator mklink /H \"$link\" \"$target\""
    if [[ ! -e "$link" ]]
    then
        ce Red fallback mode, cp \"$1\" \"$2\"
        cp "$1" "$2"
    else
        ce "Green "$link" exists!"
    fi

    # ^^ Note: useful idiom
    cd -
}

# VUNDLE
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]
then
    git clone https://github.com/VundleVim/Vundle.vim.git \
              ~/.vim/bundle/Vundle.vim

    git clone https://github.com/powerline/fonts.git ~/github/fonts
    ~/github/fonts/install.sh
fi
# DOTFILES
for dir in "bin" "dotfiles" "config/mopidy" "config/nixpkgs"
do
    echo "dir=$dir"
    if [[ "$dir" == "dotfiles" ]]
    then
        # Implicit $dir/file ~/.file rename
        to_dir_prefix="$HOME/."
    elif [[ "$dir" == config* ]]
    then
        # Implicit $dir/config/path/to/file ~/.config/path/to/file rename
        to_dir_prefix="$HOME/.$dir/"
    else
        to_dir_prefix="$HOME/$dir/"
    fi
    echo "to_dir_prefix=$to_dir_prefix"

    if [[ ! -e "$to_dir_prefix" ]]
    then
        echo "Creating $to_dir_prefix"
        mkdir -p "$to_dir_prefix"
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
        if is_windows_bash
        then
            if win_check_link "$to"
            then
                # Remove symbolic links ...
		ce Red Removing symbolic link: $(ce Green "$to")
                rm "$to"
            fi
        else
            if [[ -L "$to" ]]
            then
                # Remove symbolic links ...
                rm "$to"
            fi
        fi

        if [[ -e "$to" ]]
        then
            # ... backup real files.
            backups="$HOME/backups"
            timestamp=$(date +%Y%m%d%H%M%S)

            echo "Backing up $to => $backups/$file.$timestamp"
            [[ -d "$backups" ]] || mkdir -p "$backups"
            # Ignore directories though.
            [[ ! -d "$to" ]] && mv -f "$to" "$backups/$file.$timestamp"
        fi

        if is_windows_bash
        then
            win_create_link "$from" "$to"
        else
            ln -s "$from" "$to"
            ls -l "$to"
        fi
    done
done

declare -r touch=".touch"
if ! $(find "$touch" -mtime +1 -print >/dev/null)
then
    # Update plugins after .vimrc is updated (but once a day max)
    vim '+PluginInstall!' +qall
fi

# go
mkdir -p ~/gocode/bin
# gitconfig hack for work
[[ "$(whoami)" == "jjones" ]] && sed -i \
        's/james@jones77.com/jjones18@bloomberg.net/' dotfiles/gitconfig
# https://nixos.org/nix/
[[ -f '/home/jjones/.nix-profile/etc/profile.d/nix.sh' ]] \
    || curl https://nixos.org/nix/install | sh
# APPEND TO DOT PROFILE
[[ -f "$HOME/.bash_profile" ]] && profile_file="$HOME/.bash_profile" \
                               || profile_file="$HOME/.profile"
declare -r spg="source ~/.profile.general"
function add_spg {
    echo "$spg" >> "$profile_file"
    echo "$spg added to $profile_file"
}
grep '^source.*\.profile\.general$' "$profile_file" 1>/dev/null 2>&1 || add_spg
ce Yellow "Source it:"
ce Green "    source $profile_file"
# END
touch "$touch"
