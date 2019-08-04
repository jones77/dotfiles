#!/usr/bin/env bash

set -o errexit

# Configure symbolic links
ln -fs `pwd`/fortune.sh ~/bin/fortune.sh
ln -fs `pwd`/gasbgone.sh ~/bin/gasbgone.sh

# Update fortune
cd ~/bin
./fortune.sh update

# Update .profile.fortune
echo "alias f=fortune.sh"  > "$HOME/.profile.fortune"
echo "fortune.sh f"       >> "$HOME/.profile.fortune"

# FIXME: What does this do? Does this happen automatically?
source ~/.profile.extra
