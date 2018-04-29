#!/usr/bin/env bash

# Run in Debug mode.
set -x

# Add repositories, Update and Upgrade.

for line in $(cat sources.list); do
    sudo add-apt-repository -y $line
    if [[ ! $? -eq 0 ]]; then
        echo "Problem in add-apt-repository $line" >> output.log
    fi
done

sudo apt -y update | tee -a output.log
sudo apt -y upgrade | tee -a output.log

# Install Applications listed in `applications.list` file.

for line in $(cat applications.list); do
    sudo apt -y install $line
    if [[ ! $? -eq 0 ]]; then
        echo "Problem in apt install $line" >> output.log
    fi
done

# sudo apt install oracle-java8-installer | tee -a output.log

if [ "$egrep -c '(svm|vmx)' /proc/cpuinfo" > 0 ]; then
    sudo apt -y install qemu-kvm libvirt-bin \
        bridge-utils virt-manager | tee -a output.log
    # sudo adduser `id -un` libvirtd | tee -a output.log
fi

# install Slack and Skype
sudo snap install skype --classic
sudo snap install slack --classic

# download platform tools for android from Google
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip

# download Anaconda 5.1 Python 3.6 version
wget https://repo.anaconda.com/archive/Anaconda3-5.1.0-Linux-x86_64.sh

# kill bluetooth on startup
sudo systemctl stop bluetooth.service
sudo systemctl disable bluetooth.service

# vim configuration file
wget -O ./data/dotfiles/.vimrc https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/basic.vim
shopt -s dotglob | tee -a output.log
cp -a ./data/dotfiles/.vimrc ~ | tee -a output.log

## to be checked ----------------------------------
# .bashrc includes .persistent_history settings
# cp -a ./data/dotfiles/.bashrc ~ | tee -a output.log
## ------------------------------------------------

# Firefox Add-ons: Download and Install
wget https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/platform:2/addon-506646-latest.xpi
wget https://addons.mozilla.org/firefox/downloads/file/812203/ublock_origin-1.14.22-an+fx.xpi
wget https://www.eff.org/files/https-everywhere-latest.xpi
firefox addon-506646-latest.xpi
firefox https-everywhere-latest.xpi
firefox ublock_origin-1.14.22-an+fx.xpi

# dconf commands for initial app and system settings
dconf write /org/gnome/terminal/legacy/default-show-menubar false

dconf write /org/gnome/gedit/preferences/editor/auto-indent true
dconf write /org/gnome/gedit/preferences/editor/bracket-matching true
dconf write /org/gnome/gedit/preferences/editor/display-line-numbers true
dconf write /org/gnome/gedit/preferences/editor/display-right-margin true
dconf write /org/gnome/gedit/preferences/editor/highlight-current-line true
dconf write /org/gnome/gedit/preferences/editor/tabs-size 4
dconf write /org/gnome/gedit/preferences/editor/tabs-size uint32 4

dconf write /org/gnome/desktop/peripherals/touchpad/speed 0.5
dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click true
dconf write /org/gnome/desktop/peripherals/touchpad/two-finger-scrolling-enabled true

dconf write /org/gnome/desktop/interface/clock-show-date true

dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled true
dconf write /org/gnome/shell/enabled-extensions ['TopIcons@phocean.net', 'places-menu@gnome-shell-extensions.gcampax.github.com']
dconf write /org/gnome/shell/enabled-extensions ['TopIcons@phocean.net', 'places-menu@gnome-shell-extensions.gcampax.github.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com']

dconf write /org/gnome/desktop/wm/preferences/button-layout 'appmenu:minimize,maximize,close'

# gsettings for Videos (Totem Media Player)
gsettings set org.gnome.totem subtitle-font 'Ubuntu Mono 15'
gsettings set org.gnome.totem active-plugins ['movie-properties', 'variable-rate', 'apple-trailers', 'media_player_keys', 'save-file', 'skipto', 'screenshot', 'opensubtitles', 'vimeo', 'screensaver', 'recent', 'autoload-subtitles']
