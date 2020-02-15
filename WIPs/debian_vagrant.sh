# https://stackoverflow.com/questions/18878117/using-vagrant-to-run-virtual-machines-with-desktop-environment
sudo sed -i 's/^allowed_users=console$/allowed_users=anybody/' \
    /etc/X11/Xwrapper.config
# https://askubuntu.com/questions/233064/why-am-i-getting-command-deb-not-found/233069
# https://wiki.debian.org/VirtualBox
echo 'deb http://download.virtualbox.org/virtualbox/debian stretch contrib' | sudo tee /etc/apt/sources.list.d/virtualbox.list
curl -O https://www.virtualbox.org/download/oracle_vbox_2016.asc
sudo apt-key add oracle_vbox_2016.asc
sudo apt-get update
sudo apt-get install virtualbox-5.1
