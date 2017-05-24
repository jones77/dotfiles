# Based on https://gist.github.com/xkniu/0b752143a5990cdb3379

# you may need sudo permission to execute some commands or swith to root
# if installed old version by yum, remove it first
sudo yum remove -y tmux libevent libevent-devel libevent-headers

# install deps
sudo yum install -y gcc kernel-devel make ncurses-devel

# create temp dir
rm -rf /tmp/for-latest-tmux
mkdir /tmp/for-latest-tmux

# downloads libenvent and install
cd /tmp/for-latest-tmux/ && mkdir ./libenvent && cd ./libenvent
wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
tar -zxvf libevent-2.0.22-stable.tar.gz
cd libevent-2.0.22-stable/
./configure && make
sudo make install

# downloads tmux and install
cd /tmp/for-latest-tmux/ && mkdir ./tmux && cd ./tmux
wget https://github.com/tmux/tmux/releases/download/2.4/tmux-2.4.tar.gz
tar -zxvf tmux-2.4.tar.gz
cd tmux-2.4/
./configure && make
sudo make install

hash tmux
echo LD_LIBRARY_PATH=/usr/local/lib tmux -V
LD_LIBRARY_PATH=/usr/local/lib tmux -V

# remove temp dir if needed
rm -rf /tmp/for-latest-tmux
