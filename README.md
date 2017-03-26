# Scripts

Dotfiles and `~/bin` configuration.

# `files.sh`

Creates symbolic links for `./dotfiles/*` to `"$HOME"`.

# `packages.sh`

Tried to install some initial apt/yum packages.  eg `ruby` which is needed by
linuxbrew, `sudo` in case I'm on a Debian machine, `strace` just because.  Then
installs [Linuxbrew](http://linuxbrew.sh/) and more packages (eg the latest
versions of tmux and go).
