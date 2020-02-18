#!/usr/bin/env bash
# fortune.sh installer
set -o errexit

source ~/.shelllib.sh

# Configure symbolic links
ln -fs "$(pwd)/fortune.sh" ~/bin/fortune.sh
ln -fs "$(pwd)/gasbgone.sh" ~/bin/gasbgone.sh

# Update fortune
cd ~/bin
./fortune.sh update

__add_line_once ~/.profile.extra 'alias ff="fortune.sh f"'
__add_line_once ~/.profile.extra 'fortune.sh f'
