#!/usr/bin/env bash

if [ -d "$HOME/bin" ]
then
    ln -s fortune.sh ~/bin/fortune.sh
    ln -s gasbgone.sh ~/bin/gasbgone.sh
fi
