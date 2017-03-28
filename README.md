Dotfiles and `~/bin` configuration.

# `files.sh`

Creates symbolic links for `./dotfiles/*` to `"$HOME"`.

# `packages.sh`

Tried to install some initial apt/yum packages.  eg `ruby` which is needed by
linuxbrew, `sudo` in case I'm on a Debian machine, `strace` just because.  Then
installs [Linuxbrew](http://linuxbrew.sh/) and more packages (eg the latest
versions of tmux and go).

# Tips

I found the following combo very useful.  As recommended by: 
https://nickjanetakis.com/blog/create-an-awesome-linux-development-environment-in-windows-with-vmware

[VMWare Player 7](https://my.vmware.com/web/vmware/free#desktop_end_user_computing/vmware_player/7_0)

[XUbuntu 14](http://mirror.us.leaseweb.net/ubuntu-cdimage/xubuntu/releases/14.04/release/xubuntu-14.04.2-desktop-amd64.iso)
