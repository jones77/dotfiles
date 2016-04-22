#!/bin/bash
#############
# FUNCTIONS #
#############
my_update() {
    local my_file="$1"
    curl --progress-bar \
        http://www.asciiartfarts.com/fortune.txt \
        >"${my_file}"
    strfile "${my_file}" "${my_file}.dat"
}
my_usage_exit() {
    echo "Usage:    `basename $0` update|fortune|string"
    exit 0
}
my_script_dir() {
    local my_path="`dirname \"$0\"`"  # relative
    my_path="`( cd \"$my_path\" && pwd )`"  # absolute, normalized
    if [ -z "$my_path" ]
    then
        echo "Error: '$my_path' doesn't exist"
        exit 1
    fi
    echo "$my_path"
}
my_strings() {
    fortune "${LOCAL_FILE}" >${TEMP_FILE}
    ./gasbgone.sh ${TEMP_FILE}
}
########
# MAIN #
########
set -e  # stop on first error
TEMP_FILE=$( tempfile -s "`basename $0`" )
trap "rm -f '$TEMP_FILE'" exit  # clean up TEMP_FILE on exit
cd `my_script_dir`
LOCAL_FILE="fortune.txt"

case "$1" in
    u*) my_update "${LOCAL_FILE}" ;;
    f*) fortune   "${LOCAL_FILE}" ;;
    s*) my_strings                ;;
    *)  my_usage_exit             ;;
esac
