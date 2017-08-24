#!/usr/bin/env bash
#
# grab the ip address from lines like:
#   "MESSAGE" : "Failed password for root from 59.63.166.102 port 53187 ssh2"
# and sort them into something like:

# FIXME: Use https://www.abuseipdb.com/api.html

set -o errexit
set -o nounset
# set -o xtrace
# set -o pipefile

declare -r dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare -r journalctl_file="journalctl.json-pretty"
declare -r failed_ssh_ips_files="failed_password_ips.txt"

#
# Main
#

if [[ -f "$journalctl_file" ]]
then
    echo Using $journalctl_file
else
    echo Generating $journalctl_file
fi

time journalctl -o json-pretty >$journalctl_file

pv $journalctl_file | grep 'Failed password' \
    | awk -F'from ' '{ print $2 }' \
    | awk '{ print $1 }' \
    | sort \
    | uniq -c \
    | sort -n \
    > "$failed_ssh_ips_files"
