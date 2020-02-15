#!/usr/bin/env bash
#
# configure -h for help, quick and dirty developer install
#
# Note: Installing Linuxbrew on RHEL needs the following workaround:
# https://github.com/Linuxbrew/brew/issues/340#issuecomment-294900797
cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd  # cd $script_dir
source dotfiles/shelllib.sh
source packages/packagelib.sh
declare -r basename=$(basename $0)
declare -r indent=$(echo $basename | sed 's/./~/g')

distro="$(lsb_release -i 2>/dev/null | cut -f)"
if [[ "$distro" = "RedHatEnterpriseServer" ]]
then
    :
elif [[ "$distro" = "Ubuntu" ]]
then
    :
elif [[ "$distro" = "Debian" ]]
then
    :
elif $(hash pacman 2>/dev/null)
then
    distro="ArchLinux"
elif $(grep -i centos /etc/os-release 2>/dev/null 1>&2)
then
    distro="Centos"
elif $(uname -a | grep FreeBSD >/dev/null 2>&1)
then
    distro="FreeBSD"
else
    ce Red "$(ce Green $basename): Unknown distro: uname -a=$(uname -a)"
    exit 1
fi

case $distro \
in
Centos|RedHatEnterpriseServer)
# FIXME: Make installing 'Development Tools' dependent on -d
sudo yum groupinstall -y 'Development Tools'
# FIXME: Make 'X Window System' install dependent on -x
sudo yum groupinstall -y 'X Window System'
# FIXME: Do we need epel-release if we rely on Linuxbrew?
# sudo yum install -y epel-release
# FIXME: Aren't these redundant?
sudo yum install -y irb python-devel python-setuptools

;;

Debian)
sudo apt-get update -y
# FIXME: Create per OS install scripts.
declare -r install_cmd="sudo apt-get install -y $distropkgs \
    python-pip x11-xserver-utils"

# Firefox
# debmozlist="/etc/apt/sources.list.d/debian-mozilla.list"
# debmozkeyring="pkg-mozzila-archive-keyring_1.1_all.deb"
# if [[ ! -f "$debmozlist" ]]
# then
#     # https://www.google.com/search?q=NO_PUBKEY+85A3D26506C4AE2A
#     # http://www.hangelot.eu/?p=209&lang=en
#     sudo apt-get install debian-keyring
#     gpg --keyserver keys.gnupg.net --recv-key 06C4AE2A
#     gpg -a --export 06C4AE2A | sudo apt-key add -
#     # https://medium.com/@mos3abof/how-to-install-firefox-on-debian-jessie-90fa135e9e9
#     sudo touch "$debmozlist"
#     echo 'deb http://mozilla.debian.net/ jessie-backports firefox-release' \
#         | sudo tee "$debmozlist"
#     wget "mozilla.debian.net/$debmozkeyring"
#     sudo dpkg -i            "$debmozkeyring"
#     sudo apt-get update -y
#     sudo apt-get install -y -t jessie-backports firefox
#     sudo rm "$debmozkeyring"
# fi
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
Ubuntu)
# FIXME: Ubuntu specific instead of defaulting to Ubuntu
# elif [[ "$distro" = "???ubuntu" ]]
declare -r install_cmd="sudo apt-get install -y echo $distropkgs python-dev"
;;
FreeBSD)
declare -r install_cmd="sudo pkg"
sudo pkg install git tmux vim \
    xorg hs-xmonad hs-xmonad-contrib hs-xmobar \
    :
;;
*)
ce Red "$(ce Green $basename): Unknown distro: uname -a=$(uname -a)"
exit 1
;;
esac
