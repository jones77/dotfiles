#!/usr/bin/env bash
# 
# configure.sh args
#     quick and dirty developer install
#
declare -r basename=$(basename $0)

# Minimum apt packages we want.
PACKAGES="
curl
ntp
python-pip
python-virtualenv
ruby
strace
sudo
"

distro=$(lsb_release -i | cut -f2)

if [[ "$distro" = "RedHatEnterpriseServer" ]]
then
    sudo yum groupinstall -y 'Development Tools'
    sudo yum install -y curl git irb python-setuptools ruby
    install_cmd="sudo yum install -y"
    PACKGES="$PACKAGES python-devel"
# if [[ "$distro" = "??ubuntu" ]]
else
    install_cmd="sudo apt-get install -y"
    PACKGES="$PACKAGES python-dev"
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

# FIXME: Installing on RHEL needs the following workaround:
# https://github.com/Linuxbrew/brew/issues/340#issuecomment-294900797

# Linuxbrew packages.
BREW="
fortune
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
    ~/.linuxbrew/bin/brew ls --versions $b || (
        echo "$basename: brew: Installing $b"
        ~/.linuxbrew/bin/brew install "$b"
    )
done
