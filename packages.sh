#!/usr/bin/env bash
#
# configure -h for help, quick and dirty developer install
#
# Note: Installing Linuxbrew on RHEL needs the following workaround:
# https://github.com/Linuxbrew/brew/issues/340#issuecomment-294900797
source ~/.shelllib.sh
declare -r basename=$(basename $0)
declare -r indent=$(echo $basename | sed 's/./~/g')
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
#
# END args
#
# -----------------------------------------------------------------------------
#
# BEGIN distro package configuration
#
if $(hash lsb_release 2>/dev/null)
then
    # Ubuntu, RedHat
    distro=$(hash lsb_release && lsb_release -i | cut -f2)
elif $(hash pacman 2>/dev/null)
then
    distro="ArchLinux"
elif $(grep -i centos /etc/os-release 2>/dev/null 1>&2)
then
    distro="Centos"
fi

ce White "$(ce Green $basename): Installing $(ce Yellow $distro) Packages:"
ce Yellow "${indent}  $(ce Green ${distropkgs})"

case $distro \
in

Centos|RedHatEnterpriseServer)
# Linuxbrew workarounds for Centos 7.3
# Building from source might be overkill
export HOMEBREW_BUILD_FROM_SOURCE=1
# vim wouldn't compile without brew's perl
# vim wouldn't run without brew's python
PRE_LINUX_BREW_INSTALL="echo yes \
    | $HOME/.linuxbrew/bin/brew install perl python"

# FIXME: Make installing 'Development Tools' dependent on -d
sudo yum groupinstall -y 'Development Tools'
# FIXME: Make 'X Window System' install dependent on -x
sudo yum groupinstall -y 'X Window System'
# FIXME: Do we need epel-release if we rely on Linuxbrew?
sudo yum install -y epel-release
# FIXME: Aren't these redundant?
sudo yum install -y irb python-devel python-setuptools

declare -r install_cmd="sudo yum install -y $distropkgs"
;;

Debian)
sudo apt-get update -y
declare -r install_cmd="sudo apt-get install -y $distropkgs python-pip x11-xserver-utils"
# FIXME: Create per OS install scripts.
debmozlist="/etc/apt/sources.list.d/debian-mozilla.list"
debmozkeyring="pkg-mozzila-archive-keyring_1.1_all.deb"
if [[ ! -f "$debmozlist" ]]
then
    # https://www.google.com/search?q=NO_PUBKEY+85A3D26506C4AE2A
    # http://www.hangelot.eu/?p=209&lang=en
    sudo apt-get install debian-keyring
    gpg --keyserver keys.gnupg.net --recv-key 06C4AE2A
    gpg -a --export 06C4AE2A | sudo apt-key add -
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
declare -r install_cmd="sudo apt-get install -y echo $distropkgs python-dev"
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
    brewcmd="$HOME/.linuxbrew/bin/brew"
    [[ -f "$brewcmd" ]] || ( echo yes | ruby -e "$(curl -fsSL \
        'https://raw.githubusercontent.com/Linuxbrew/install/master/install')"
    )
    eval "$PRE_LINUX_BREW_INSTALL"
    echo yes | $brewcmd install curl git
    echo yes | $brewcmd install $linuxbrew_pkgs

    # Haskell stack specific
    # www.stephendiehl.com/posts/vim_2016.html
    # echo yes | $brewcmd install stack
    # stack setup
    # stack install hlint ghc-mod
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
