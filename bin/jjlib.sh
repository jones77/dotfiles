#!/usr/bin/env bash

# aliases
alias cp="cp -i"
alias ls="ls --color --group-directories-first"
alias mv="mv -i"
alias rm="rm -i"
alias v="vim"

# functions
function hh() {
    hostname
    uname -a
    lsb_release -a
}

# Used by percent.sh, for example:
#   usage_exit "$#" 2 "`basename $0` part total" "$@"
function usage_exit() {  # args: argc argc_check usage
    argc="$1"       && shift
    argc_check="$1" && shift
    usage="$1"      && shift
    if (( argc != argc_check ))
    then
        echo "Usage:    $usage"
        exit 1
    fi
}

function azify() {
    # http://stackoverflow.com/a/23816607/469045
    echo "$@" | tr -dc '[:alnum:]' | tr '[:upper:]' '[:lower:]'
}

