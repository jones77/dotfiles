#!/usr/bin/env bash
# 
# configure.sh args
#     quick and dirty developer install
#
set -e
declare -r basename=$(basename $0)

# Minimum apt packages we want.
APT="
ruby
strace
sudo
"

for a in $APT
do
    echo "----aa---- $a" 
    apt show "$a" || (
        echo "$basename: apt: Installing $a"
    )
done

# Linuxbrew itself.
hash brew || (
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
)

# Linuxbrew packages.
BREW="
fortune
git
go
tmux
vim
"

for b in $BREW
do
    echo "----bb---- $b"
    hash $b || (
        echo "$basename: brew: Installing $b"
        brew install "$b"
    )
done
