#!/usr/bin/env bash
#MAIN#

if (( $# != 1 ))
then
    echo "Usage:    `basename $0` file"
    exit 1
fi

set -e
my_temp_file=$( tempfile -s "`basename $0`" )
trap "rm -f '$my_temp_file'" exit  # clean up my_temp_file on exit
local_file="$1"
unique_length=5  # Number of unique characters
string_limit=5  # Number of unique characters

# strip leading space
# strip trailing space
# reduce multiple spaces to a single space
# and then do the same for 3-or more repeated letters
# 
# delete blank lines
cat ${local_file} | sed \
    -e 's/[^a-z A-Z]*//g' \
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
    >"${my_temp_file}"

cat ${my_temp_file} | while read line
do
    num_chars=`echo "$line" | wc -c`
    num_unique_chars=`echo "$line" \
        | sed -e 's/\(.\)/\1\n/g' | sort | uniq -c | sort -n | wc -l`

    if (( num_unique_chars > unique_length && num_chars > string_limit ))
    then
        echo "$line"
    fi
done
