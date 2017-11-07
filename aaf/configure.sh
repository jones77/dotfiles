#!/usr/bin/env bash
ln -s `pwd`/fortune.sh ~/bin/fortune.sh
ln -s `pwd`/gasbgone.sh ~/bin/gasbgone.sh
cd ~/bin
./fortune.sh update
echo "alias f=fortune.sh"  > "$HOME/.profile.fortune"
echo "fortune.sh f"       >> "$HOME/.profile.fortune"
source ~/.profile.extra
