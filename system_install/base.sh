#!/bin/sh
if [ -z "$username" ]; then
    echo 'Set the `username` variable'
    exit 1
fi

if [ -z "$hostname" ]; then
    echo 'Set the `hostname` variable'
    exit 1
fi

## Install zsh
# To be set as the shell for new users
pacman --quiet --noconfirm --needed -S zsh

## User and groups
# Groups
groupadd -r autologin
echo "%wheel    ALL=(ALL) ALL" >> /etc/sudoers

# Root password
echo "Set password for root: "
passwd

# Add user
useradd -m -G wheel,audio,video,autologin,storage -s `which zsh` "$username"
echo "Set password for $username:"
passwd "$username"

## Hostname
echo "$hostname" > /etc/hostname
echo -e "127.0.1.1 \t $hostname.lo \t $hostname" >> /etc/hosts

## Time and locale
echo "Enter your timezone. E.g., 'Europe/London'"
read timezone
ln -s "/usr/share/zoneinfo/$timezone" /etc/localtime
hwclock --systohc --utc

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

timedatectl set-ntp true # time sync daemon

## Basic tools
pacman --quiet --noconfirm --needed -S base-devel
pacman --quiet --noconfirm --needed -S wget rsync git-core
pacman --quiet --noconfirm --needed -S openssh ca-certificates
pacman --quiet --noconfirm --needed -S base-devel
pacman --quiet --noconfirm --needed -S curl wget rsync git-core
pacman --quiet --noconfirm --needed -S vim  # Just basic editing, we'll install neovim in user_tools.sh
pacman --quiet --noconfirm --needed -S atool tar gzip zip unzip unrar
pacman --quiet --noconfirm --needed -S python3 python-pip
pacman --quiet --noconfirm --needed -S accountsservice # used by lightdm

# USB auto-mount
pacman --quiet --noconfirm --needed -S udevil udisks2 ntfs-3g
chmod -s /usr/bin/udevil


## Drivers & codecs
# Graphic drivers
echo "Install graphic drivers in the shell below and close it to proceed with installation."
echo "It is advised to consult the Arch Wiki, e.g. https://wiki.archlinux.org/index.php/intel_graphics"
zsh

# Video codecs
pacman --quiet --noconfirm --needed -S libx264

# Audio
echo "Installing audio software: in case of problems after installation see"
echo "'amixer' output (unmute if needed) and try running 'alsactl init' "
echo "or 'alsactl store' or 'pavucontrol'"
pacman --quiet --noconfirm --needed -S mpg123
pacman --quiet --noconfirm --needed -S pulseaudio pulseaudio-alsa pavucontrol
pacman --quiet --noconfirm --needed -S alsa-utils


## Display
# X11
pacman --quiet --noconfirm --needed -S xorg-server xorg-xrdb xorg-xinit xorg-xmodmap libxrandr
pacman --quiet --noconfirm --needed -S xorg-xfontsel xorg-xlsfonts  # Run xfontsel to select fonts in X format, xlsfonts lists installed (cached) fonts

# XDG
pacman --quiet --noconfirm --needed -S xdg-utils

# light display manager with autologin
# (I had trouble configuring newer versions of nodm)
pacman --quiet --noconfirm --needed -S lightdm
pacman --quiet --noconfirm --needed -S lightdm-gtk-greeter # it won't run
    # without a greeter, even with autologin, but we already have GTK
    # somewhere so this is lightweight
systemctl enable lightdm.service

echo "[Seat:*]
user-session=xmonad
pam-service=lightdm
pam-autologin-service=lightdm-autologin
session-wrapper=/etc/lightdm/Xsession
autologin-user=$username
autologin-user-timeout=0" > /etc/lightdm/lightdm.conf

mkdir -p /usr/share/xsessions
echo "[Desktop Entry]
Name=XMonad
Encoding=UTF-8
Exec=/home/ondra/.start-xmonad.sh
Type=XSession" > /usr/share/xsessions/xmonad.desktop


# Interface
pacman --quiet --noconfirm --needed -S termite
pacman --quiet --noconfirm --needed -S rofi
pacman --quiet --noconfirm --needed -S xclip
pacman --quiet --noconfirm --needed -S numlockx  # utility to turn on numlock
pacman --quiet --noconfirm --needed -S feh  # image viewer, shows background

# Fonts
pacman --quiet --noconfirm --needed -S ttf-dejavu ttf-ubuntu-font-family
pacman --quiet --noconfirm --needed -S otf-ipafont # Japanese
pacman --quiet --noconfirm --needed -S ttf-liberation  # used by chrome


## User tools
# Text editing
pacman --quiet --noconfirm --needed -S neovim
pip3 install neovim-remote  # Used with vimtex
pacman --quiet --noconfirm --needed -S dos2unix

# PDF
pacman --quiet --noconfirm --needed -S zathura zathura-pdf-mupdf zathura-ps
xdg-mime default zathura.desktop application/pdf
pacman --quiet --noconfirm --needed -S xdotool  # Required to connect zathura with vim-latex

# Music
pacman --quiet --noconfirm --needed -S mpd
pacman --quiet --noconfirm --needed -S ncmpc

# IRC
pacman --quiet --noconfirm --needed -S irssi

# Writing
pacman --quiet --noconfirm --needed -S texlive-most biber
pacman --quiet --noconfirm --needed -S aspell aspell-en

# Network
pacman --quiet --noconfirm --needed -S openvpn
pacman --quiet --noconfirm --needed -S net-tools
pacman --quiet --noconfirm --needed -S bind-tools

# General programming
pacman --quiet --noconfirm --needed -S valgrind
pacman --quiet --noconfirm --needed -S lua  # Used by vim plugin Shougo/neocomplete

# Python
pip install flake8  # syntax checking for python with syntastic
pip install clf
