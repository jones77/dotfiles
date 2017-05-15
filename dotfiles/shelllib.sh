#!/usr/bin/env bash
# Useful script library functions, ie `source library.sh`
function ce {  # color echo, eg ce Green string [...]
    (( $# == 0 )) && return 0  # http://stackoverflow.com/questions/3666846
    # http://stackoverflow.com/a/5947802
    # https://en.wikipedia.org/wiki/ANSI_escape_code
    # FIXME: Add background colors.
    local Black="0;30"
    local Blue="0;34"
    local BrownOrange="0;33"
    local Cyan="0;36"
    local DarkGray="1;30"
    local Green="0;32"
    local LightBlue="1;34"
    local LightCyan="1;36"
    local LightGray="0;37"
    local LightGreen="1;32"
    local LightPurple="1;35"
    local LightRed="1;31"
    local Purple="0;35"
    local Red="0;31"
    local White="1;37"
    local Yellow="1;33"
    local NoColor='0' # No Color
    local color_name="$1" col nocol
    shift
    col=$(eval echo \$$color_name)
    if [[ -n "$col" ]]
    then
        echo -e "\e[${col}m$@\e[${NoColor}m"   
    else
        # Didn't understand the command, fallback to regular echo.
        set "$color_name $@"
        echo "$@"
    fi
}
#
ce Green running .shelllib.sh
#
original_dir="$(pwd)"
script_pathtoname="$(
                 ps -f | grep $$ | grep $PPID | awk '{ print $NF }')"
script_dir="$(dirname '$script_pathtoname')"
script_name="$(basename '$script_pathtoname')"
#
function sl_debug {
    [[ -n "$DEBUG" ]] && echo "$@"
}
sl_debug "original_dir=$script_dir"
sl_debug "script_dir=$script_dir"
sl_debug "script_name=$script_name"
# OO bash?
function script {
    case "$1" in
        'dir')  get_script_dir ;;
        'cd')   cd_script_dir ;;
        'name') get_script_name ;;
        'back') cd_back ;;
    esac
}
#
## FUNCTIONS ##
# ... and we move to the scripts dir.  Until we get to the end of the program.
function cd_back {
    # On error we return to where we were ...
    cd "$original_dir"
}
function cd_script_dir {
    cd "$script_dir"
}
function get_script_dir {
    echo "$script_dir"
}
function get_script_name {
    echo "$script_name"
}
