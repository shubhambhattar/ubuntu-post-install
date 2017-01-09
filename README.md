# ubuntu-post-install
A script to install various applications and configuring them after fresh installation of Ubuntu (tested in Ubuntu GNOME 16.04.1 x64 LTS, Ubuntu GNOME 16.10 x64).

Inspired from this blog: http://blog.self.li/post/74294988486/creating-a-post-installation-script-for-ubuntu

## Run the following commands

```
wget https://github.com/shubhambhattar/ubuntu-post-install/archive/master.zip
unzip master.zip
cd ubuntu-post-install-master
chmod +x script.sh
./script.sh
```

### Basic Structure
The repository is organised in a specific way. Explanation given below:

- [data](https://github.com/shubhambhattar/ubuntu-post-install/tree/master/data): This folder contains config files or packages of installed applications.
    - [st3](https://github.com/shubhambhattar/ubuntu-post-install/tree/master/data/st3): This folder contains - User settings, Packages and Snippets for Sublime Text 3.
    - [atom](https://github.com/shubhambhattar/ubuntu-post-install/tree/master/data/atom): This folder contians - User settings and Snippets for Atom.
    - [dotfiles](https://github.com/shubhambhattar/ubuntu-post-install/tree/master/data/dotfiles): This folder contains the various dot config files like `.vimrc`, `.bashrc`, etc.

- [script.sh](https://github.com/shubhambhattar/ubuntu-post-install/blob/master/script.sh): This shell script installs applications and sets up configuration files for different applications in their appropriate places. The script first adds all the PPAs, updates and upgrades the system, installs the applications and at last, configures the installed applications.
