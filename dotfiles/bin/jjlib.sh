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

