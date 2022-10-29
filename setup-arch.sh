#!/bin/sh

# This script sets up a minimal Arch Linux desktop with i3-gaps window manager.
# Some additional conveniences and eye-candy are included as well.
# You need to install `sudo` and `yay` before running this script and to run
# this script from a sudoer account (NOT root).

#URL_TOUCHPAD="https://gist.githubusercontent.com/harej/2b498b3999a1a2a8b481e994bcb8a686/raw/2a926e1fd5eecbe96e90836b827fbbf149bec4fc/30-touchpad.conf"

# TODO: check if script is being run as root

# TODO: check if sudo is installed

mkdir -p ~/.config
mkdir -p ~/.config/btop
mkdir -p ~/.config/fish
mkdir -p ~/.config/i3
mkdir -p ~/.config/kitty
mkdir -p ~/.config/picom
mkdir -p ~/.config/polybar
mkdir -p ~/.config/rofi

cp ./dotfiles/btop/* ~/.config/btop
cp ./dotfiles/fish/* ~/.config/fish
cp ./dotfiles/i3/* ~/.config/i3
cp ./dotfiles/kitty/* ~/.config/kitty
cp ./dotfiles/picom/* ~/.config/picom
cp ./dotfiles/polybar/* ~/.config/polybar
cp ./dotfiles/rofi/* ~/.config/rofi

echo "rofi.theme: ${HOME}/.config/rofi/slate.rasi" > ~/.config/rofi/config

yay -Syu

sudo pacman -Syu --noconfirm

# Wallpaper

cp ./backgrounds/bg.jpg ~/.config/bg.jpg

# Basic packages and dependencies for compiling btop and i3-gaps

sudo pacman -S --noconfirm \
	nano \
	git \
	make \
	coreutils \
	sed \
	curl \
	unzip \
	tmux \
	btop \
	neofetch \
	xorg \
	i3-gaps

# TODO: terminal font picker

sudo pacman -S --noconfirm \
	polybar \
	rofi \
	kitty \
	feh \
	picom \
	ttf-roboto \
	cryptsetup \
	thunar \
	cowsay \
	lxsession \
	cmatrix \
	youtube-dl \
	fish \
	docker \
	docker-compose

# Fish shell

echo /usr/bin/fish | sudo tee -a /etc/shells

chsh -s /usr/bin/fish

# TODO: change gtk3 and gtk4 themes

# TODO: browser picker

yay -S --noconfirm \
	sublime-text-4 \
	nerd-fonts-complete

# TODO: text editor picker

#wget ${URL_TOUCHPAD}

#sudo mv 30-touchpad.conf /etc/X11/xorg.conf.d/

#sudo virsh net-define /usr/share/libvirt/networks/default.xml

#sudo virsh net-autostart default

#sudo virsh net-start default

# Install `ly` display manager

mkdir build

cd build

git clone --recurse-submodules https://github.com/fairyglade/ly

cd ly

make

sudo make install installsystemd

cd ../../

# Installing fonts

sudo cp ./fonts/* /usr/share/fonts

# TODO: x11vnc (install, set password, create custom systemctl file, reload daemon, enable service)

# Permissions

chmod +x ~/.config/polybar/launch.sh

# Enabling services

sudo systemctl enable ly.service
sudo systemctl enable docker

# Done!

cd ..

cowsay -b "Scatter Desktop is now installed. Reboot your system to activate"
