#!/usr/bin/env bash
# Configure & customize development environment.
set -o errexit
cd "$(dirname "${BASH_SOURCE[0]}")"  # Always Be Local.
source ./home/dotfiles/shelllib.sh   # Relative link to latest version.
__symbolic_links=""                  # Symbolic links we created.

# Dependencies:
# - Go (vim completor)
# - python3.7-psutil (tmux-cpu-info.py)

# TODO: Add options, eg disable installing vim plugins

recreate_custom_profile() {
    touch ~/.profile.custom
    cat <<EOF >~/.profile.custom
#!/usr/bin/env bash
source ~/.shelllib.sh
export JJ77_PYTHON='$(command -v python3.7)'
export JJ77_GOCODE='$(command -v gocode)'
ce Green running .profile.custom
EOF
    source ~/.profile.custom
    echo "JJ77_PYTHON=$JJ77_PYTHON"
    echo "JJ77_GOCODE=$JJ77_GOCODE"
}
pip_it() {
    sudo pip3.7 install jedi psutil || :  # Forgive this failure.
}
configure_golang() {
    ce Green configuring golang
    mkdir -p ~/go/bin
    go get -u github.com/nsf/gocode  # needed by maralla/completor

    go get   golang.org/x/tools/cmd/guru
    go build golang.org/x/tools/cmd/guru
    mv guru ~/go/bin
}
configure_vim() {
    vim '+PluginInstall' +qall 2>&1
}
fear_the_repos() {  # FIXME: Use WIPs/autosrc.
    git_clone() {
        repo="$1" dir="$2"
        [[ -d $dir ]] || git clone "$repo" "$dir"  # clone if it ain't.
    }
    git_clone "https://github.com/VundleVim/Vundle.vim.git" \
       ~/.vim/bundle/Vundle.vim  # Note: Don't "~", you'll get a literal "~".
    git_clone "https://github.com/powerline/fonts.git" ~/src/github/fonts
    git_clone "https://github.com/mbadolato/iTerm2-Color-Schemes.git" \
        ~/src/github/iTerm2-Color-Schemes
}
configure_dotfiles() {  # Symlinks ./home/... files to eg, $HOME/. and $HOME/bin
    for dir in home/*
    do
        to_subdir=${dir#home/}
        case $to_subdir in
            # Figure out the *prefix* to prepend to a destination.
            dotfiles) to_prefix="$HOME/."  # eg "${to_prefix}/.${to}"
            ;;
            *) to_prefix="$HOME/$to_subdir/"  # eg ${HOME}/${to_subdir}/${to}"
            ;;
        esac

        printf "%s %s %s %s%s\n" \
            "$(ce Yellow "linking from")" \
            "$(ce Cyan "$to_subdir")" \
            "$(ce Yellow "to")" \
            "$(ce Green "$to_prefix")" \
            "$(ce Yellow "<filename>")"

        for filename in "$dir"/*
        do
            if [[ $filename =~ .swp$ || $filename =~ ^Session.vim$ ]]
            then
                ce Red "Skipping VIM swapfile: $filename"
                continue
                # FIXME: Use .gitignore to ignore more file types
            fi

            from="$(pwd)/${filename}"
            to="${to_prefix}${filename##*/}"

            [[ -L "$to" ]] && rm "$to"  # Remove previous symbolic links.
            ln -s "$from" "$to"
            __symbolic_links="$__symbolic_links $to"
        done
    done
}

configure_git_config() {
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
}
configure_profile() {
    # Add to .bash_profile or .profile?
    if [[ -f "$HOME/.bash_profile" ]] && [[ -f "$HOME/.profile" ]]
    then
        ce Yellow "Info: Both .bash_profile and .profile exist in $HOME"
    elif [[ -f "$HOME/.bash_profile" ]]
    then
        profile_file="$HOME/.bash_profile"
    elif [[ -f "$HOME/.profile" ]]
    then
        profile_file="$HOME/.profile"
    else
        ce Red "Warning: Neither .bash_profile nor .profile exist in $HOME"
    fi
    __add_line_once "$profile_file" "source ~/.profile.general"
    ce Yellow "Source it:" && ce Green "    source $profile_file"
}
print_links() {
    for symbolic_link in $__symbolic_links
    do
        __b=$(__basename "$symbolic_link")
        __p=$(__pathname "$symbolic_link")
        __b_p=$(__basename "$__p")
        __p_p=$(__pathname "$__p")
        cd "$(__pathname "$symbolic_link")"
        actual=$(readlink "$__b")
        [[ "$__p_p" != "$(__pathname "$HOME")" ]] && __b="$__b_p/$__b"
        printf "%-44s%s\n" "$(ce Cyan "$__b")" "$(ce Green "$actual")"
    done
}

########
# MAIN #
########
configure_golang
recreate_custom_profile
configure_dotfiles
pip_it
fear_the_repos
configure_vim
print_links  # FIXME: Fold into configure_dotfiles.
configure_git_config
configure_profile
