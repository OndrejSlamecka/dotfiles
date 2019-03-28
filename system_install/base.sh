#!/bin/sh
if [ -z "$username" ]; then
    echo 'Set the `username` variable'
    exit 1
fi

if [ -z "$hostname" ]; then
    echo 'Set the `hostname` variable'
    exit 1
fi

# Install shell. To be set as the shell for new users
sh="fish"
pacman --quiet --noconfirm --needed -S "$sh"

## User and groups
# Groups
groupadd -r autologin
echo "%wheel    ALL=(ALL) ALL" >> /etc/sudoers

# Root password
echo "Set password for root: "
passwd

# Add user
useradd -m -G wheel,audio,video,autologin,storage -s $(which "$sh") "$username"
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
echo "LANG=en_US.UTF-8" > /etc/locale.conf

timedatectl set-ntp true # time sync daemon

## Basic tools
pacman --quiet --noconfirm --needed -S \
    base-devel vim \
    net-tools bind-tools \
    wget rsync git \
    openssh ca-certificates \
    atool tar gzip zip unzip unrar \
    python3 python-pip \

# USB auto-mount
pacman --quiet --noconfirm --needed -S udevil udisks2 ntfs-3g
chmod -s /usr/bin/udevil


## Drivers & codecs
# Graphic drivers
echo "Install graphic drivers in the shell below and close it to proceed with installation."
echo "It is advised to consult the Arch Wiki, e.g. https://wiki.archlinux.org/index.php/intel_graphics"
$sh

# Video codecs
pacman --quiet --noconfirm --needed -S libx264

# Audio
echo "Installing audio software: in case of problems after installation see"
echo "'amixer' output (unmute if needed) and try running 'alsactl init' "
echo "or 'alsactl store' or 'pavucontrol'"
pacman --quiet --noconfirm --needed -S \
    mpg123 \
    pulseaudio pulseaudio-alsa pavucontrol \
    alsa-utils


## Display
# X11
pacman --quiet --noconfirm --needed -S \
    xorg-server xorg-xrdb xorg-xinit xorg-xmodmap xorg-xprops libxrandr \
    xorg-xfontsel xorg-xlsfonts  # Run xfontsel to select fonts in X format, xlsfonts lists installed (cached) fonts

# XDG
pacman --quiet --noconfirm --needed -S xdg-utils

# light display manager with autologin
pacman --quiet --noconfirm --needed -S \
    lightdm \
    lightdm-gtk-greeter \
    accountsservice # needed for autologin
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
Exec=/home/ondra/dotfiles/start-xmonad.sh
Type=XSession" > /usr/share/xsessions/xmonad.desktop


# Interface
pacman --quiet --noconfirm --needed -S \
    kitty \
    fzf \
    rofi \
    pass \
    xclip \
    numlockx \
    dunst \
    feh

# Fonts
pacman --quiet --noconfirm --needed -S ttf-fira-code ttf-ubuntu-font-family
pacman --quiet --noconfirm --needed -S otf-ipafont # Japanese
pacman --quiet --noconfirm --needed -S ttf-liberation  # used by chrome
pacman --quiet --noconfirm --needed -S noto-fonts-emoji


## User tools
# Text editing
pacman --quiet --noconfirm --needed -S neovim
pip install neovim
pacman --quiet --noconfirm --needed -S dos2unix

# PDF
pacman --quiet --noconfirm --needed -S zathura zathura-pdf-mupdf zathura-ps
xdg-mime default zathura.desktop application/pdf

# Music
pacman --quiet --noconfirm --needed -S mpd
pacman --quiet --noconfirm --needed -S ncmpc
