Dotfiles and more.

# `files.sh`

Creates symbolic links for `./dotfiles/*` in `"$HOME"`.

# `packages.sh`

Install some basic apt/yum packages.  eg `ruby`, needed by
linuxbrew, `sudo` in case I'm on a Debian machine, `strace` just because.  Then
installs [Linuxbrew](http://linuxbrew.sh/) and more packages (eg the latest
versions of tmux and go).

Have a look in the [`_packages/`](_packages/) directory and modify to your
heart's content.

# Tips

## Linux VM on Windows

### Freeware VMWare

* [Create an Awesome \[XUbuntu 14\] Development Environment in Windows with
  \[VWMare Player 7\]](https://nickjanetakis.com/blog/create-an-awesome-linux-development-environment-in-windows-with-vmware)
  * [VMWare Player 7](https://my.vmware.com/web/vmware/free#desktop_end_user_computing/vmware_player/7_0)
  * [XUbuntu 14](http://mirror.us.leaseweb.net/ubuntu-cdimage/xubuntu/releases/14.04/release/xubuntu-14.04.2-desktop-amd64.iso)

### Various Vagrants

* [jones77/vagrants](https://github.com/jones77/vagrants)

## Cheatsheets

[git](https://www.git-tower.com/blog/content/posts/54-git-cheat-sheet/git-cheat-sheet-large01.png)
[pep8](http://i.imgur.com/ckjEZOi.png)
[virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/)
[xmonad](https://wiki.haskell.org/wikiupload/b/b8/Xmbindings.png)

## General

Fix timezone: `sudo timedatectl set-timezone America/New_York`

You want [**powerline fonts**](https://github.com/powerline/fonts) for `vim` and
`tmux`.  [This is where **Deja Vu Sans Mono** lives, the world's greatest
programmer font.](https://github.com/powerline/fonts/tree/master/DejaVuSansMono)

# TODO

- rename github to git

# Building vim

# Debian

    ./configure --with-features=huge \
        --enable-multibyte=yes \
        --enable-python3interp=yes \
        --enable-pythoninterp=yes \
        --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu
