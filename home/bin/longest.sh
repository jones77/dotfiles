#!/usr/bin/env bash

declare -r __basename="$(basename "${BASH_SOURCE[0]}")"

if [[ ! -f "$1" ]]
then
    echo "usage: $__basename filename"
    echo 1
fi

file="$1"

max_diff=0
max_diff_num=0
previous=0
while read -r num
do
    diff=$((num - previous))
    if (( diff > max_diff ))
    then
        max_diff="$diff"
        max_diff_num="$previous"
    fi
    printf "%s\t%s\n" "$diff" "$previous"

    previous="$num"
done <"$file"
printf "max: %s\t%s\n" "$max_diff" "$max_diff_num"
