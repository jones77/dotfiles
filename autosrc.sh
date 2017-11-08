#!/usr/bin/env bash

# TODO: test non-git repo checkouts
# TODO: implement option based version

set -o nounset && set -o errexit && set -o pipefail
# set -xtrace && set -verbose
# based on: https://github.com/jones77/shlintro
__usage() { cat <<USAGE
Usage: ${__basename} [OPTION]... [CONFIG_FILE]...

  Automatically checkout source repositories.

  Config file format (columns in square brackers, eg [optional] are optional):

    repo [subdir] [remote_repo remote_name branch]

  repos are assumed to have either of the following formats:

    https://domain/user/repo, eg https://github.com/jones77/shlintro
    git@domain:user/repo.git, eg git@github.com:jones77/shlintro.git

  If subdir is _, repos are checked out to $HOME/src/repo.
  If subdir is specified, repos are checked out to $HOME/src/subdir/repo.

Example:
  ${__basename} repo.cfg

Example CONFIG_FILE:

    https://a.tv/b/c _ https://a.tv/atvorg/upstream upstream master upstream
    https://github.com/b/c" github

Options:
  -h, --help    Show this help and exit
  -f, --force   Force checkout (backs up existing directories to $HOME/backups)
  -n, --dry-run Perform a trial run with no changes made
  -v, --verbose Debug trace
USAGE
};__shopts="hfnv"
__longopts="help,force,dry-run,verbose"
__basename="$(      basename "${BASH_SOURCE[0]}" )"
__dirname="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
__fatal(){ [[ -n "$@" ]] && printf "$__basename: $@\n\n"; __usage; exit 1;}
__args=$(set +e && getopt -T || if (( $? == 4 )); then
    getopt -s"bash" -o"${__shopts}" -l"${__longopts}" -n"${__basename}" -- "$@"
    else echo 'bad getopt version: getopt -T || (( $? == 4 )) is false'; exit 1
fi) && eval set -- "${__args}" || __fatal ""  # If we call __fatal "" then
# getopt has already printed invalid option -- 'x' or unrecognized option '--x'
is_force=
dry_run=
verbose=": ||"  # default: ignore trace
while (( $# ))
do
    case $1 in
	-h|--help) __usage && exit 0 ;;
	--) shift && break  # [FILES]... argument parsing, shift && break
            ;;
        -f|  --force) shift && is_force=true ;;
        -n|--dry-run) shift &&  dry_run="echo dry-run:" ;;
        -v|--verbose) shift &&  verbose="echo debug:" ;;
	*) __fatal "unknown option: $1" ;;
   esac
done

while (( $# ))
do
    config_file=$1 && shift  # FIXME: read from stdin?
    if [[ ! -f $config_file ]]
    then
        __fatal "$config_file does not exist"
    fi

    cat "$config_file" | while read line
    do
        $verbose "Parsing: $line"
        read -r url subdir remote_url remote_name remote_branch branch <<< "$line"
        $verbose "Parsed: url=$url subdir=$subdir" \
            "remote_url=$remote_url remote_name=$remote_name" \
            "remote_branch=$remote_branch branch=$branch"

        if [[ $line == \#* ]]
        then
            # TODO: Make verbose only
            $verbose "Ignoring $line"
            continue
        elif [[ $line == *git@* ]] || [[ $line == *https://* ]]
        then
            :
        elif [[ $url != *.git ]]
        then
            :
        else
            # TODO: Line Numbers
            __fatal "Syntax Error in $config_file: $line"
        fi

        if [[ "$url" == git@* ]] && [[ "$url" == *.git ]]
        then
           url=${url%.git}  # git@github.com:jones77/shlintro.git
        fi                          #                          trims ^^^^

        repo=${url##*/}  # aka basename(url)
        todir="$HOME/src/$subdir/$repo"

        if [[ -e $todir ]]
        then
            if [[ $is_force == true ]]
            then
                # backup previous folders
                backups="$HOME/backups"
                timestamp=$(date +%Y%m%d%H%M%S)
                todir_basename=$(basename "$todir")
                echo "Backing up $todir => $backups/${todir_basename}.${timestamp}"
                [[ -d "$backups" ]] || $dry_run mkdir -p "$backups"
                $dry_run mv -f "$todir" "$backups/${todir_basename}.${timestamp}"
            else
                echo "Ignoring $todir"
                continue
            fi
        fi

        echo "Cloning $url => $todir"
        $dry_run git clone -q "$url" "$todir"

        if [[ -n $remote_url ]]
        then
            (
                $verbose "cd $todir" && cd $todir
                echo "Remoting $remote_url $remote_name/$remote_branch $branch"
                $dry_run git remote add "$remote_name" "$remote_url"
                $dry_run git fetch "$remote_name"
                $dry_run git checkout -b "$branch" "$remote_name/$remote_branch"
            )
        fi
    done
    shift
done
