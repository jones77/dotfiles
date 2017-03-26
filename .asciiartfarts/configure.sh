#!/usr/bin/env bash

if [ -d "$HOME/bin" ]
then
    ln -s `pwd`/fortune.sh ~/bin/fortune.sh
    ln -s `pwd`/gasbgone.sh ~/bin/gasbgone.sh
fi
