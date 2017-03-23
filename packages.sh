#!/usr/bin/env bash
# 
# configure.sh args
#     quick and dirty developer install
#
set -e
declare -r basename=$(basename $0)

# Minimum apt packages we want.
PACKAGES="
ruby
strace
sudo
"

distro=$(lsb_release -i | cut -f2)

if [[ "$distro" = "RedHatEnterpriseServer" ]]
then
    test_cmd="rpm -q"
    install_cmd="sudo yum install"
else
    test_cmd="apt show"
    install_cmd="sudo apt-get install"
fi

for a in $PACKAGES
do
    echo "----aa---- $a" 
    $test_cmd "$a" || (
        echo "$basename: apt: Installing $a"
        $install_cmd "$a"
    )
done

# Linuxbrew itself.
hash brew || (
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
)

# Linuxbrew packages.
BREW="
fortune
git
go
tmux
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
