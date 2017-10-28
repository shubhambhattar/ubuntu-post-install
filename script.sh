#!/usr/bin/env bash

# add repositories, update and upgrade

for line in $(cat sources.list); do
    sudo add-apt-repository -y $line | tee -a output.log;
done

# sudo add-apt-repository -y ppa:webupd8team/atom | tee output.log
# sudo add-apt-repository -y ppa:webupd8team/sublime-text-3 | tee -a output.log
# sudo add-apt-repository -y ppa:slgobinath/safeeyes | tee -a output.log
# sudo add-apt-repository -y ppa:yg-jensge/shotwell | tee -a output.log
# sudo add-apt-repository -y ppa:gezakovacs | tee -a output.log

sudo apt -y update | tee -a output.log
sudo apt -y upgrade | tee -a output.log

# install the application of PPA
# redshift is not required with Ubuntu GNOME 17.04+
sudo apt -y install \
    atom sublime-text-installer vim build-essential safeeyes \
    sqlitebrowser weechat vlc chromium-browser gparted \
    filezilla unetbootin unrar shotwell | tee -a output.log

# install java
# sudo apt install oracle-java8-installer | tee -a output.log
sudo apt install default-jre default-jdk

if [ "$egrep -c '(svm|vmx)' /proc/cpuinfo" > 0 ]; then
    sudo apt -y install qemu-kvm libvirt-bin \
        bridge-utils virt-manager | tee -a output.log
    # sudo adduser `id -un` libvirtd | tee -a output.log
fi

# download platform tools for android from Google
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip

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

## to be checked ----------------------------------
# .bashrc includes .persistent_history settings
# cp -a ./data/dotfiles/.bashrc ~ | tee -a output.log
## ------------------------------------------------

# add `.persistent_history` code to `.bashrc`
cat data/persistent_history_code.sh >> ~/.bashrc


# Firefox addons download and install
wget https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/platform:2/addon-506646-latest.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/adblock-plus/addon-1865-latest.xpi
firefox addon-506646-latest.xpi
firefox addon-1865-latest.xpi

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
