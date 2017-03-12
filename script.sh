#!/usr/bin/env bash

# add repositories, update and upgrade
sudo add-apt-repository -y ppa:webupd8team/atom | tee output.log
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3 | tee -a output.log
sudo apt-add-repository -y ppa:webupd8team/java | tee -a output.log
sudo add-apt-repository -y ppa:slgobinath/safeeyes | tee -a output.log
sudo add-apt-repository -y ppa:varlesh-l/indicator-kdeconnect | tee -a output.log
sudo add-apt-repository -y ppa:gezakovacs | tee -a output.log
sudo apt -y update | tee -a output.log
sudo apt -y upgrade | tee -a output.log

# install the application of PPA

sudo apt -y install \
    atom sublime-text-installer idle vim g++ safeeyes \
    redshift sqlitebrowser weechat vlc chromium-browser \
    gparted filezilla kdeconnect unetbootin unrar | tee -a output.log

# install java
sudo apt install oracle-java8-installer | tee -a output.log

if [ "$egrep -c '(svm|vmx)' /proc/cpuinfo" > 0 ]; then
    sudo apt -y install qemu-kvm libvirt-bin \
        bridge-utils virt-manager | tee -a output.log
    # sudo adduser `id -un` libvirtd | tee -a output.log
fi

# kill bluetooth on startup and start redshift
# sudo sed -i -e '$i rfkill block bluetooth \nredshift \n' /etc/rc.local | tee -a output.log
sudo systemctl stop bluetooth.service
sudo systemctl disable bluetooth.service

# sublime-text-3 - configurations, snippets and packages
mkdir -p ~/.config/sublime-text-3/Installed\ Packages/ | tee -a output.log
mkdir -p ~/.config/sublime-text-3/Packages/User/ | tee -a output.log

cp data/st3/Installed-Packages/Package\ Control.sublime-package \
    ~/.config/sublime-text-3/Installed\ Packages/ | tee -a output.log
cp -ar data/st3/Packages/User/* ~/.config/sublime-text-3/Packages/User | tee -a output.log

# install atom packages
apm install autocomplete-python highlight-selected \
    advanced-open-file atom-runner linter-gcc \
    markdown-preview-plus | tee -a output.log

# configuration and snippets in atom
cp data/atom/* ~/.atom/ | tee -a output.log

# vim configuration file
shopt -s dotglob | tee -a output.log
cp -a ./data/dotfiles/.vimrc ~ | tee -a output.log
