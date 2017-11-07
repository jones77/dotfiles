#!/usr/bin/env bash
set -o errexit && set -o pipefail && : # set -o xtrace
__basename="$(      basename "${BASH_SOURCE[0]}" )"
__dirname="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare -r __tmpfile=$( tempfile -s "`basename $0`" )
declare -r __fortune_file="fortune.txt"
__usage_exit() {
    echo "Usage:    `basename $0` update|fortune|string"
    exit 0
}
__update() {
    local -r my_file="$1"
    local -r http_aaf="aHR0cDovL3d3dy5hc2NpaWFydGZhcnRzLmNvbS9mb3J0dW5lLnR4dA=="

    curl --progress-bar $(echo "$http_aaf"|base64 -d) >"${my_file}"
    strfile "${my_file}" "${my_file}.dat"
}
__gasbgone() {
    fortune "$__fortune_file" >${__tmpfile}
    ./gasbgone.sh ${__tmpfile}
}
# Main
trap "rm -f '$__tmpfile'" exit  # clean up __tmpfile on exit
cd "$__dirname"
case "$1" in
    u*) __update "$__fortune_file"  ;;
    f*) fortune "$__fortune_file"   ;;
    s*) __gasbgone                  ;;
    *)  __usage_exit                ;;
esac
