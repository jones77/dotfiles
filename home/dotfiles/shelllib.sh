#!/usr/bin/env bash
# Useful script library functions, ie `source library.sh`
# http://wiki.bash-hackers.org/scripting/terminalcodes

# This broke on FreeBSD
# Foreground
# export __fg_Black=$(tput setaf 0)
# export __fg_Red=$(tput setaf 1)
# export __fg_Green=$(tput setaf 2)
# export __fg_Yellow=$(tput setaf 3)
# export __fg_Blue=$(tput setaf 4)
# export __fg_Magenta=$(tput setaf 5)
# export __fg_Cyan=$(tput setaf 6)
# export __fg_White=$(tput setaf 7)
# # FIXME: What's tput setaf 8 do?
# export __fg_Default=$(tput setaf 9)
# # Foreground
# export __bg_Black=$(tput setab 0)
# export __bg_Red=$(tput setab 1)
# export __bg_Green=$(tput setab 2)
# export __bg_Yellow=$(tput setab 3)
# export __bg_Blue=$(tput setab 4)
# export __bg_Magenta=$(tput setab 5)
# export __bg_Cyan=$(tput setab 6)
# export __bg_White=$(tput setab 7)
# # FIXME: What's tput setab 8 do?
# export __bg_Default=$(tput setab 9)

# export __NoColor=$(tput sgr0)

# http://stackoverflow.com/a/5947802
__fg_Black="0;30"
__fg_Blue="0;34"
__fg_BrownOrange="0;33"
__fg_Cyan="0;36"
__fg_DarkGray="1;30"
__fg_Green="0;32"
__fg_BoldBlue="1;34"
__fg_BoldCyan="1;36"
__fg_BoldGray="0;37"
__fg_BoldGreen="1;32"
__fg_BoldPurple="1;35"
__fg_BoldRed="1;31"
__fg_Purple="0;35"
__fg_Red="0;31"
__fg_White="1;37"
__fg_Yellow="1;33"

__fg_bgRed="\e[41"
__fg_bgGreen="\e[42"

function ce {  # color echo, eg ce Green string [...]
    (( $# == 0 )) && return 0  # http://stackoverflow.com/questions/3666846
    # https://en.wikipedia.org/wiki/ANSI_escape_code
    # FIXME: Add background colors.
    local color_name="$1"
    local col
    shift

    col="$(eval echo \$__fg_${color_name})"

    if [[ -n "$col" ]]
    then
        echo -e "\001\033[${col}m\002$@\001\033[0m\002"
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
