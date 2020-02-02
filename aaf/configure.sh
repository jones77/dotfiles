#!/usr/bin/env bash
# fortune.sh installer
set -o errexit

# Configure symbolic links
ln -fs "$(pwd)/fortune.sh" ~/bin/fortune.sh
ln -fs "$(pwd)/gasbgone.sh" ~/bin/gasbgone.sh

# Update fortune
cd ~/bin
./fortune.sh update

if grep -Fxq fortune ~/.profile.extra
then
    echo "alias f=fortune.sh" >> ~/.profile.extra
    echo "fortune.sh f"       >> ~/.profile.extra
fi
