#!/usr/bin/env bash
# Useful script library functions, ie `source library.sh`
# http://wiki.bash-hackers.org/scripting/terminalcodes

# Foreground
__fg_Black=$(tput setaf 0)
__fg_Red=$(tput setaf 1)
__fg_Green=$(tput setaf 2)
__fg_Yellow=$(tput setaf 3)
__fg_Blue=$(tput setaf 4)
__fg_Magenta=$(tput setaf 5)
__fg_Cyan=$(tput setaf 6)
__fg_White=$(tput setaf 7)
# FIXME: What's tput setaf 8 do?
__fg_Default=$(tput setaf 9)
# Foreground
__bg_Black=$(tput setab 0)
__bg_Red=$(tput setab 1)
__bg_Green=$(tput setab 2)
__bg_Yellow=$(tput setab 3)
__bg_Blue=$(tput setab 4)
__bg_Magenta=$(tput setab 5)
__bg_Cyan=$(tput setab 6)
__bg_White=$(tput setab 7)
# FIXME: What's tput setab 8 do?
__bg_Default=$(tput setab 9)

__NoColor=$(tput sgr0)

function ce {  # color echo, eg ce Green string [...]
    (( $# == 0 )) && return 0  # http://stackoverflow.com/questions/3666846
    # http://stackoverflow.com/a/5947802
    # https://en.wikipedia.org/wiki/ANSI_escape_code
    # FIXME: Add background colors.
    local color_name="$1"
    local col
    shift

    col=$(eval echo \$__fg_${color_name})

    if [[ -n "$col" ]]
    then
        echo -e "\001${col}\002$@\001${__NoColor}\002"   
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
