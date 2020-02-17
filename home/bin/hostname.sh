#!/usr/bin/env bash
# hostname truncator
# hostname.sh 12 ->

if (( $# != 1 ))
then
    echo "usage: hostname.sh num_characters"
    exit 1
fi

echo "$HOSTNAME" | sed -E "s/(.{$1})(.{1,})\$/\1…/"
