#!/usr/bin/env bash
# Fortune file downloader.
set -o errexit && set -o pipefail && : # set -o xtrace

declare -r __basename="$(basename "${BASH_SOURCE[0]}")"
declare -r __dirname="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# tempfile doesn't exist on Mac, silently fail and use mktemp instead
# FIXME: Is mktemp more portable?
declare -r __tmpfile="$(mktemp /tmp/fortune.XXXXXXXXXXX)"
declare -r __fortune_file="fortune.txt"
rm_tmpfile() {
    rm -f "$__tmpfile"
}
trap rm_tmpfile EXIT
cd "$__dirname"

__usage_exit() {
    echo "Usage:    $__basename update|fortune|string"
    exit 0
}

__update() {
    local -r my_file="$1"
    local -r http_aaf="aHR0cDovL3d3dy5hc2NpaWFydGZhcnRzLmNvbS9mb3J0dW5lLnR4dA=="

    curl --progress-bar "$(echo "$http_aaf"|base64 --decode)" >"$my_file"
    strfile "$my_file" "$my_file.dat"
}

__gasbgone() {
    fortune "$__fortune_file" >"$__tmpfile"
    ./gasbgone.sh "$__tmpfile"
}

# MAIN
case "$1" in
    u*) __update "$__fortune_file" ;;
    f*) fortune  "$__fortune_file" ;;
    s*) __gasbgone ;;
    *)  __usage_exit ;;
esac
