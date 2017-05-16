#!/usr/bin/env bash
#
# configure -h for help, quick and dirty developer install
#
# Note: Installing Linuxbrew on RHEL needs the following workaround:
# https://github.com/Linuxbrew/brew/issues/340#issuecomment-294900797
source ~/.shelllib.sh
declare -r basename=$(basename $0)
# -----------------------------------------------------------------------------
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
        linuxbrew_pkgs="$(list_packages l)"
    ;;
        h) usage
    ;;
        l) linuxbrew_pkgs="$(list_packages l)"
    ;;
	?)  # A specific package, quit if it doesn't exist
        if [[ -f "_packages/$opt" ]]
        then
            l=$(list_packages $opt)
            distropkgs="$distropkgs $l" \
                && echo $(ce Green $basename): Adding: $(ce green $l)

            if [[ "$opt" == "d" ]]
            then
                pip_pkgs="virtualenvwrapper"
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
echo -e "$(ce Green $basename): Installing distro packages: $(ce Green $distropkgs)"  # Note: leading space
#
# END args
#
# -----------------------------------------------------------------------------
#
# BEGIN distro package configuration
#
if $(hash lsb_release)
then
    # Ubuntu, RedHat
    distro=$(hash lsb_release && lsb_release -i | cut -f2)
elif $(hash pacman)
then
    distro="ArchLinux"
elif $(grep -i centos /etc/os-version 2>/dev/null 1>&2)
then
    distro="Centos"
fi

case $distro \
in

Centos|RedHatEnterpriseServer)

sudo yum groupinstall -y 'Development Tools'
declare -r install_cmd="sudo yum install -y $distropkgs \
        irb python-devel python-setuptools"
;;

Debian)

declare -r install_cmd="sudo apt-get install -y $distropkgs
python-pip
x11-xserver-utils
"
# FIXME: Create per OS install scripts.
debmozlist="/etc/apt/sources.list.d/debian-mozilla.list"
debmozkeyring="pkg-mozzila-archive-keyring_1.1_all.deb"
if [[ ! -f "$debmozlist" ]]
then
    # https://medium.com/@mos3abof/how-to-install-firefox-on-debian-jessie-90fa135e9e9
    sudo touch "$debmozlist"
    echo 'deb http://mozilla.debian.net/ jessie-backports firefox-release' \
        | sudo tee "$debmozlist"
    wget "mozilla.debian.net/$debmozkeyring"
    sudo dpkg -i            "$debmozkeyring"
    sudo apt-get update -y
    sudo apt-get install -y -t jessie-backports firefox
    sudo rm "$debmozkeyring"
fi
;;

ArchLinux)

# Note: --noconfirm: https://unix.stackexchange.com/a/52278 
# Note: ArchLinux's decision to make /usr/bin/python
# be Python3 is causing issues installing virtualenv.
# https://wiki.archlinux.org/index.php/python
# FIXME: Install virtualenvwrpper, python developer packages
declare -r install_cmd="sudo pacman -Syu --noconfirm $(
    echo $distropkgs $(echo '
'))"
;;
*)
# FIXME: Ubuntu specific instead of defaulting to Ubuntu
# elif [[ "$distro" = "???ubuntu" ]]
declare -r install_cmd="sudo apt-get install -y $(
    echo $distropkgs $(echo '

    python-dev

'))"
;;
esac
$install_cmd
#
# END distro configuration
#
# -----------------------------------------------------------------------------
#
# BEGIN Linuxbrew configuration
#
if [[ -n "$linuxbrew_pkgs" ]]
then
    # Get brew if we don't have it
    hash brew || (
        ruby -e "$(curl -fsSL \
            https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    )

    for b in $linuxbrew_pkgs
    do
        ~/.linuxbrew/bin/brew ls --versions $b || (
            echo "$basename: brew: Installing $b"
            ~/.linuxbrew/bin/brew install "$b"
        )
    done

    # Haskell stack specific
    # www.stephendiehl.com/posts/vim_2016.html
    stack setup
    stack install hlint ghc-mod
fi
#
# END Linuxbrew configuration
#
# -----------------------------------------------------------------------------
#
# BEGIN pip configuration
#
sudo pip install --upgrade pip
for p in $pip_pkgs
do
    sudo pip install $p
done
#
# END pip configuration
#
