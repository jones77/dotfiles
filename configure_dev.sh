#!/usr/bin/env bash
# 
# configure.sh args
#     quick and dirty developer install
# configure.sh
#     fortune
#
set -e

if (( $# ))
then
    sudo apt-get install sudo  # TODO: Is this Debian 8 only?
    sudo apt-get install ruby
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"

    brew install fortune

    brew install git
    brew install tmux
    brew install golang

else
    if [ -d "$HOME/bin" ]
    then
        ln -s fortune.sh ~/bin/fortune.sh
        ln -s gasbgone.sh ~/bin/gasbgone.sh
    fi
fi
# TODO: Enhance this script.
