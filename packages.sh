#!/usr/bin/env bash
# 
# configure.sh args
#     quick and dirty developer install
#
set -e
declare -r basename=$(basename $0)

# Minimum apt packages we want.
PACKAGES="
curl
ntp
python-dev
python-pip
python-virtualenv
ruby
strace
sudo
"

distro=$(lsb_release -i | cut -f2)

if [[ "$distro" = "RedHatEnterpriseServer" ]]
then
    install_cmd="sudo yum install"
# if [[ "$distro" = "??ubuntu" ]]
else
    install_cmd="sudo apt-get install -y"
fi

for a in $PACKAGES
do
    echo "----aa---- $a" 
    $install_cmd "$a"
done

# Linuxbrew itself.
hash brew || (
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
)

# TODO: Install dejavu sans mono automagically.
# http://askubuntu.com/questions/3697/how-do-i-install-fonts
# font-dejavu-sans-mono-for-powerline

# Linuxbrew packages.
BREW="
fortune
git
go
python
python3
tmux
the_silver_searcher
vim
"

for b in $BREW
do
    echo "----bb---- $b"
    brew ls --versions $b || (
        echo "$basename: brew: Installing $b"
        brew install "$b"
    )
done
