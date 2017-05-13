#!/usr/bin/env bash
#
# configure -h for help, quick and dirty developer install
#
# Note: Installing Linuxbrew on RHEL needs the following workaround:
# https://github.com/Linuxbrew/brew/issues/340#issuecomment-294900797
source ~/.shelllib.sh
#
# BEGIN functions
#
declare -r args="ahlpdx"
function usage {
    echo "Usage:    $basename -$args"
    cat <<EOF
a) all
h) help
l) install Linuxbrew packages: $(list_packages l)
p) install default packages: $(list_packages p)
d) install developer packages: $(list_packages d)
x) install desktop packages: $(list_packages x)
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
            [[ "$f" != "l" ]] \
                && distropkgs="$distropkgs $(list_packages $(basename $file))"
        done
        linuxbrew_packages="$(list_packages l)"
    ;;
        h) usage
    ;;
        l) linuxbrew_packages="$(list_packages l)"
    ;;
	?)  # A specific package, quit if it doesn't exist
        if [[ -f "_packages/$opt" ]]
        then
            l=$(list_packages $opt)
            distropkgs="$distropkgs $l" && echo $basename: Adding: $l
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
echo "$basename: Installing distro packages:$distropkgs"  # Note: leading space
#
# END args
#
# -----------------------------------------------------------------------------
#
# BEGIN distro package configuration
#
declare -r distro=$(lsb_release -i | cut -f2)
# FIXME: centos?
if [[ "$distro" = "RedHatEnterpriseServer" ]]
then declare -r install_cmd="
    sudo yum install -y $(echo $distropkgs $(echo '

    irb 
    python-devel 
    python-setuptools 

    '))
    sudo yum groupinstall -y 'Development Tools'
    "
# FIXME: ArchLinux specific
# FIXME: Ubuntu specific instead of defaulting to Ubuntu
# elif [[ "$distro" = "???ubuntu" ]]
else declare -r install_cmd="
        sudo apt-get install -y $(echo $distropkgs $(echo '

        python-dev

    '))
    "
fi
$install_cmd
#
# END distro configuration
#
# -----------------------------------------------------------------------------
[[ -z "$linuxbrew_packages" ]] && exit 0
# -----------------------------------------------------------------------------
#
# BEGIN Linuxbrew configuration
#
hash brew || (  # Get brew if we don't have it
    ruby -e "$(curl -fsSL \
        https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
)

for b in $linuxbrew_packages
do
    ~/.linuxbrew/bin/brew ls --versions $b || (
        echo "$basename: brew: Installing $b"
        ~/.linuxbrew/bin/brew install "$b"
    )
done
#
# END Linuxbrew configuration
#
# -----------------------------------------------------------------------------
#
# BEGIN Miscellaneous configuration
#
# FIXME: Not everybody is James Jones
git config --global user.name "James Jones"
git config --global user.email "james@jones77.com"
# 
# END Miscellaneous configuration
# 
