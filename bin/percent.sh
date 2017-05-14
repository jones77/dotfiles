#!/usr/bin/env bash
# Percentage printer.  eg percent.sh 50 100 => "50%"

usage_exit() {
    # ARGUMENTS:
    #   argc, argc_check, usage
    # EXAMPLE:
    #   usage_exit "$#" 2 "`basename $0` part total" "$@"
    argc="$1"
    argc_check="$2"
    usage="$3"
    if (( argc != argc_check ))
    then
        echo "Usage:    $usage"
        exit 1
    fi
}

usage_exit "$#" 2 "`basename $0` part total" "$@"

num=$(echo "scale=2; ($1 / $2) * 100" | bc | sed 's/[.].*//')

[[ -n "$num" ]] && echo "$num%" || echo "0%"
