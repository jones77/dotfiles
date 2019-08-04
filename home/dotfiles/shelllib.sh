#!/usr/bin/env bash

# TODO: Improve the quality of this script, maybe a library?

# Useful script library functions, ie `source shelllib.sh`
# http://wiki.bash-hackers.org/scripting/terminalcodes
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

    col="$(eval echo "\$__fg_${color_name}")"

    if [[ -n "$col" ]]
    then
        echo -e "\001\033[${col}m\002$*\001\033[0m\002"
    else
        # Didn't understand the command, fallback to regular echo.
        set "$color_name $*"
        echo "$@"
    fi
}
