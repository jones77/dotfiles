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

declare -r package_group=$(ls _packages)  # List the packages lists
declare distro_packages=""
while getopts ":$args" opt
do
    case $opt in
	a) for packages in $package_group  # All packages
        do
            distro_packages="$distro_packages $(cat _packages/$packages)"
        done
    ;;
        h) usage
    ;;
        l) declare -r linuxbrew_packages="$(cat _packages/$l)"
    ;;
	\?) if [[ -f "_packages/$OPTARG" ]]
        then
            distro_packages="$distro_packages $(cat _packages/$OPTARG)"
            echo "$basename: Added $OPTARG packages"
        else
            echo "$basename: Quitting, Unknown option: $OPTARG"
            usage
        fi
    ;;
  esac
done
[[ -z "$distro_packges" ]] && distro_packages=$(cat _packages/p)  # Default
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
    sudo yum install -y $(echo $distro_packages $(echo '

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
        sudo apt-get install -y $(echo $distro_packages $(echo '

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
