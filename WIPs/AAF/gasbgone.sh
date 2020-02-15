#!/usr/bin/env bash
#MAIN#

if (( $# != 1 ))
then
    echo "Usage:    $(basename "$0") file"
    exit 1
fi

set -e
my_temp_file="$(mktemp)"
rm_tmpfile() {
    rm -f "$my_temp_file"
}
trap rm_tmpfile EXIT

local_file="$1"
unique_length=5  # Number of unique characters
string_limit=5  # Number of unique characters

# strip leading space
# strip trailing space
# reduce multiple spaces to a single space
# and then do the same for 3-or more repeated letters
#
# delete blank lines
sed -e 's/[^a-z A-Z]*//g' \
    -e 's/^\s*//g' \
    -e 's/\s*$//g' \
    -e 's/\s\s*/ /g' \
    -e '/^\s*$/d' \
    \
    -e 's/^\(.\)\1\1\1*//g' \
    -e 's/\(.\)\1\1\1*$//g' \
    -e 's/*\(.\)\1\1\1/ /g' \
    -e '/^*\(.\)\1\1\1$/d' \
    \
    -e '/^.$/d' \
    -e '/^..$/d' \
    -e '/^...$/d' \
    \
    >"${my_temp_file}" \
    <"$local_file"

while read -r line
do
    num_unique_chars="$(echo "$line" \
        | sed -e 's/\(.\)/\1\n/g' | sort | uniq -c | sort -n | wc -l)"

    if (( num_unique_chars > unique_length && ${#line} > string_limit ))
    then
        echo "$line"
    fi
done <"$my_temp_file"
