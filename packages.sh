#!/usr/bin/env bash
#
# TODO: Install dejavu sans mono automagically.
# http://askubuntu.com/questions/3697/how-do-i-install-fonts
# font-dejavu-sans-mono-for-powerline
#
# FIXME: Installing on RHEL needs the following workaround:
# https://github.com/Linuxbrew/brew/issues/340#issuecomment-294900797
# 
# configure.sh args
#     quick and dirty developer install
#
# BEGIN functions
#
declare -r original_dir=$(pwd)
function cdback {
    # Error handling returns you to where you were on error
    cd "$original_dir"
}
trap cdback ERR
cd $(dirname "${BASH_SOURCE[0]}")  # cd me

declare -r basename=$(basename $0)
declare -r args="ahlpdx"

function list_packages {
    echo $(cat _packages/$1)
}
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

declare -r package_files=$(ls _packages/*)  # List the packages lists
distropkgs=""
while getopts ":$args" opt
do
    echo "$basename: Processing option: $opt"
    case $opt in
	a) for file in $package_files  # All packages
        do
            distropkgs="$distropkgs $(cat _packages/$(basename file))"
        done
    ;;
        h) usage
    ;;
        l) linuxbrew_packages="$(cat _packages/$l)"
    ;;
	?) if [[ -f "_packages/$opt" ]]
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
[[ -z "$distropkgs" ]] && distropkgs=$(cat _packages/p)  # Default
echo "$basename: Installing distro packages: $distropkgs"
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
#
# BEGIN Linuxbrew configuration
#
[[ -z "$install_linux_brew" ]] && exit 0  # jk

hash brew || (
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
)

# Linuxbrew packages.
for b in $BREW
do
    echo "----bb---- $b"
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
cdback
# 
# END Miscellaneous configuration
# 
