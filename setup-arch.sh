#!/bin/sh

# This script sets up a minimal Arch Linux desktop with i3-gaps window manager.
# Some additional conveniences and eye-candy are included as well.
# You need to install `sudo` and `yay` before running this script and to run
# this script from a sudoer account (NOT root).

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
mkdir -p ~/.vnc

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
	btop \
	coreutils \
	curl \
	git \
	i3-gaps \
	make \
	nano \
	neofetch \
	sed \
	tmux \
	unzip \
	x11vnc \
	xorg

echo "exec i3" > ~/.xinitrc

# TODO: terminal font picker

sudo pacman -S --noconfirm \
	cmatrix \
	cowsay \
	cryptsetup \
	docker-compose \
	docker \
	feh \
	fish \
	kitty \
	lxsession \
	picom \
	polybar \
	rofi \
	thunar \
	ttf-jetbrains-mono \
	ttf-roboto \
	youtube-dl

# Fish shell

echo /usr/bin/fish | sudo tee -a /etc/shells

chsh -s /usr/bin/fish

# TODO: change gtk3 and gtk4 themes

# TODO: browser picker

yay -S --noconfirm \
	ungoogled-chromium-bin \
	sublime-text-4

# TODO: text editor picker

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

# x11vnc

x11vnc -storepasswd vnc ~/.vnc/passwd

cat ./services/x11vnc.service | sed -r s/jh/${USER}/ > ./build/x11vnc.service

sudo cp ./build/x11vnc.service /etc/systemd/system/x11vnc.service

# Permissions

chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.xinitrc

# Enabling services

sudo systemctl daemon-reload
sudo systemctl enable ly.service
sudo systemctl enable docker.service
sudo systemctl enable x11vnc.service

# Done!

cd ..

cowsay -b "Scatter Desktop is now installed. Reboot your system to activate"
