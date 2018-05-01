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
chmod +x Anaconda3-5.1.0-Linux-x86_64.sh
./Anaconda3-5.1.0-Linux-x86_64.sh

# kill bluetooth on startup
sudo systemctl stop bluetooth.service
sudo systemctl disable bluetooth.service

# vim configuration file
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

# turn Location Services on
gsettings set org.gnome.system.location enabled true

# add a sleep command so that Location Service can identify the location properly
# the following commands will be executed after 10 seconds
sleep 10

# Change default settings for Gedit
gsettings set org.gnome.gedit.preferences.editor auto-indent true
gsettings set org.gnome.gedit.preferences.editor bracket-matching true
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.gedit.preferences.editor display-right-margin true
gsettings set org.gnome.gedit.preferences.editor highlight-current-line true
gsettings set org.gnome.gedit.preferences.editor tabs-size 4

dconf write /org/gnome/desktop/interface/clock-show-date true

dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled true

# Change default settings for Terminal
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
profile=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "\'")
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/ use-system-font false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/ font 'Monospace 14'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/ audible-bell false

gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.5

dconf write /org/gnome/desktop/datetime/automatic-timezone true

# gsettings for Videos (Totem Media Player)
gsettings set org.gnome.totem subtitle-font 'Ubuntu Mono 15'
dconf write /org/gnome/Totem/active-plugins "['vimeo', 'variable-rate', 'skipto', 'screenshot', 'screensaver', 'save-file', 'recent', 'movie-properties', 'opensubtitles', 'media_player_keys', 'autoload-subtitles', 'apple-trailers']"
dconf write /org/gnome/totem/autoload-subtitles true

# turn Location Services Off
gsettings set org.gnome.system.location enabled false

echo "-------------------------------------------------"
echo "goto 'about:config' in firefox and set 'layout.css.devPixelsPerPx' to 1.25"
echo "-------------------------------------------------"
