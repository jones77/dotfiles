#!/usr/bin/env bash

function usage_exit() {
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

# aliases
alias ls="ls --color --group-directories-first"
