# My dotfiles & more for quick environment configuration

## `configure_env.sh`

Creates symbolic links in `$HOME/*` for files in `./home/bin` and
`./home/dotfiles`.

eg

    $HOME/.vimrc -> home/dotfiles/vimrc
    $HOME/bin/mandelbrot.sh -> home/bin/mandelbrot

# Tips

## Linux VM on Windows

### Freeware VMWare

* [Create an Awesome \[XUbuntu 14\] Development Environment in Windows with
  \[VWMare Player 7\]](https://nickjanetakis.com/blog/create-an-awesome-linux-development-environment-in-windows-with-vmware)
  * [VMWare Player 7](https://my.vmware.com/web/vmware/free#desktop_end_user_computing/vmware_player/7_0)
  * [XUbuntu 14](http://mirror.us.leaseweb.net/ubuntu-cdimage/xubuntu/releases/14.04/release/xubuntu-14.04.2-desktop-amd64.iso)

### Various Vagrants

* [jones77/vagrants](https://github.com/jones77/vagrants)

### Hyper-V

https://www.windowscentral.com/how-run-linux-distros-windows-10-using-hyper-v

https://www.netometer.com/blog/?p=1663

https://hyperv.veeam.com/blog/how-to-configure-hyper-v-virtual-switch/

## Cheatsheets
<!-- one-word links to quickstarts and cheatsheets -->

[bash](http://kvz.io/blog/2013/11/21/bash-best-practices/)
[git](https://www.git-tower.com/blog/content/posts/54-git-cheat-sheet/git-cheat-sheet-large01.png)
[pep8](http://i.imgur.com/ckjEZOi.png)
[virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/)
[xmonad](https://wiki.haskell.org/wikiupload/b/b8/Xmbindings.png)

## Change Timezone

    sudo timedatectl set-timezone America/New_York

## Powerline Fonts

You want [**powerline fonts**](https://github.com/powerline/fonts) for `vim` and
`tmux`.  [This is where **Deja Vu Sans Mono** lives, the world's greatest
programmer font.](https://github.com/powerline/fonts/tree/master/DejaVuSansMono)
