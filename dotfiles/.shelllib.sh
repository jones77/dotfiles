#!/usr/bin/env bash
# Useful script library functions, ie `source library.sh`
#
# http://stackoverflow.com/questions/3666846/how-do-you-return-to-a-sourced-bash-script#comment15666398_3666941
declare -r INCLUDED_SHELL_LIB_SH=true || return 0
declare -r original_dir="$(pwd)"
declare -r script_pathtoname="$(
                            ps -f | grep $$ | grep $PPID | awk '{ print $NF }')"
declare -r script_dir="$(dirname '$script_pathtoname')"
declare -r script_name="$(basename '$script_pathtoname')"
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
