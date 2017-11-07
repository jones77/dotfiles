#!/usr/bin/env bash
#
# source _inc_packagelib.sh
#

# -----------------------------------------------------------------------------
#
# BEGIN functions
#
declare -r args="ahlpdxy"
function usage {
    echo "Usage:    $basename -$args"
    cat <<EOF
a) all
h) help
l) install Linuxbrew packages: $(list_packages l)
p) install default packages: $(list_packages p)
d) install developer packages: $(list_packages d)
x) install desktop packages: $(list_packages x)
y) install pip packages: $(list_packages y)
EOF
    exit 1
}
function list_packages {
    echo $( echo $(cat _packages/$1) )
}
declare -r package_files=$(ls _packages/*)  # List the packages lists
distropkgs=""  # Note: First package added adds a leading space
while getopts ":$args" opt
do
    case $opt in
	a)  # All packages
        for file in $package_files
        do
            f=$(basename $file)
            # Linuxbrew and Python packages are different
            [[ "$f" != "l" ]] && [[ "$f" != "y" ]] \
                && distropkgs="$distropkgs $(list_packages $(basename $file))"
        done
        linuxbrew_pkgs="$(list_packages l)"
        pip_pkgs="$(list_packages y)"
    ;;
        h) usage
    ;;
        l) linuxbrew_pkgs="$(list_packages l)"
    ;;
        y) pip_pkgs="$pip_pkgs $(list_packages y)"
    ;;
	?)  # A specific package, quit if it doesn't exist
        if [[ -f "_packages/$opt" ]]
        then
            l=$(list_packages $opt)
            distropkgs="$distropkgs $l" \
                && echo $(ce Green $basename): Adding: $(ce green $l)

            if [[ "$opt" == "d" ]]
            then
                pip_pkgs="$pip_pkgs virtualenvwrapper"
            fi
        else
            echo "$basename: Quitting, Unknown opt: $opt"
            usage
        fi
    ;;
    esac
done
shift $((OPTIND-1))
#
[[ -z "$distropkgs" ]] && distropkgs=$(list_packages p)  # Default
#
#
# END args
