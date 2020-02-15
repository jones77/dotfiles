#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__checkout() {
    if (( $# != 4 ))
    then
        echo "Wrong number of arguments, $#: $@"
        exit 1
    fi

    # subdir url upstream_repo/upstream_branch local_branchname
    subdir="$1" url="$2" rebr="$3" lcl_br="$4"

    if [[ -z $subdir ]] || [[ -z $url ]] || [[ -z $rebr ]] || [[ -z $lcl_br ]]
    then
        echo "Unexpected empty argument: $@"
        exit 1
    fi

    mkdir -p "$subdir"
}

__checkout 'src/bitbucket/scripts' 'https://bitbucket.org/jones77/scripts' \
    'upstream/master' 'master'
__checkout 'src/bitbucket/scripts' 'https://github.com/jones77/scripts' \
    'github/master' 'github'
__checkout 'src/bitbucket/scripts' 'https://github.com/jones77/scripts' \
    'github/develop' 'develop'

# scripts
cat <<EOF

src/bitbucket/scripts upstream master master 'https://bitbucket.org/jones77/scripts'
- upstream master master 'https://bitbucket.org/jones77/scripts'
https://github.com/jones77/scripts github master github
# shlintro
https://github.com/jones77/shlintro
# scratch
https://bitbucket.org/jones77/scratch
# https://github.com/sjl/t
https://github.com/sjl/t github
EOF


