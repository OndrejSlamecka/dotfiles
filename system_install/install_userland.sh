#!/bin/sh
if [ -n "$username" ]; then
    echo 'Set the `username` variable'
    exit 1
fi

# Synchronize time using systemd-timesyncd
timedatectl set-ntp true

# The very basic tools
pacman --noconfirm -S wget rsync git-core

## User and groups

# Groups
groupadd -r autologin
echo "%wheel    ALL=(ALL) ALL" >> /etc/sudoers

# Add user
useradd -m -G wheel,audio,video,autologin -s `which zsh` "$username"
echo "Set password for $username:"
passwd "$username"

# Switch to user, setup folders and dotfiles
su - $username

mkdir -p $HOME/tmp $HOME/.config
mkdir -p $HOME/Music

git clone https://github.com/OndrejSlamecka/dotfiles.git $HOME/dotfiles && cd $HOME/dotfiles && ./install.sh
logout


## Basic tools
pacman --noconfirm -S openssh ca-certificates
pacman --noconfirm -S base-devel
pacman --noconfirm -S zsh
pacman --noconfirm -S curl wget rsync git-core
pacman --noconfirm -S vim  # Just basic editing, we'll install neovim in user_tools.sh
pacman --noconfirm -S atool tar gzip zip unzip
pacman --noconfirm -S python3
pacman --noconfirm -S udevil  # USB hot-plugging TODO: This may need further setup
pacman --noconfirm -S accountsservice # used by lightdm

## AUR helper
# Pacaur -- run as user, first fetch Dave Reisner's key to verify cower
su - $username
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 487EACC08557AD082088DABA1EB2638FF56C0C53

buildroot="$(mktemp -d)"
mkdir -p "$buildroot" && cd "$buildroot"

git clone "https://aur.archlinux.org/cower.git"
git clone "https://aur.archlinux.org/pacaur.git"

cd "${buildroot}/cower"  && makepkg --syncdeps --install --noconfirm
cd "${buildroot}/pacaur" && makepkg --syncdeps --install --noconfirm

cd "$HOME" && rm -rf "$buildroot"

pacaur -Syu --aur
logout

## Drivers & codecs
# Graphic drivers
echo "Install graphic drivers in the shell below and close it to proceed with installation."
echo "It is advised to consult the Arch Wiki, e.g. https://wiki.archlinux.org/index.php/intel_graphics"
zsh

# Video codecs
pacman --noconfirm -S libx264

# Audio
echo "Installing audio software: in case of problems after installation see"
echo "'amixer' output (unmute if needed) and try running 'alsactl init' or 'alsactl store'"
pacman --noconfirm -S mpg123
pacman --noconfirm -S alsa-utils


## Display
# X11
pacman --noconfirm -S xorg-server xorg-xrdb xorg-xinit xorg-xmodmap libxrandr
pacman --noconfirm -S xorg-xfontsel xorg-xlsfonts  # Run xfontsel to select fonts in X format, xlsfonts lists installed (cached) fonts

# XDG
pacman --noconfirm -S xdg-utils

# light display manager with autologin
# (I had trouble configuring newer versions of nodm)
pacman --noconfirm -S lightdm
pacman --noconfirm -S lightdm-gtk-greeter # it won't run without a greeter, even with autologin,
                              # but we already have GTK somewhere so this is lightweight
systemctl enable lightdm.service

echo "[Seat:*]
pam-service=lightdm
pam-autologin-service=lightdm-autologin
session-wrapper=/etc/lightdm/Xsession
autologin-user=$username
autologin-user-timeout=0" > /etc/lightdm/lightdm.conf

mkdir -p /usr/share/xsession
echo "[Desktop Entry]
Name=XMonad
Encoding=UTF-8
Exec=/home/ondra/.start-xmonad.sh
Type=XSession" > /usr/share/xsession/xmonad.desktop


## Haskell
su - $username
pacaur -S libtinfo  # Needed for Stack
logout
echo "Add haskell-core repository https://wiki.archlinux.org/index.php/ArchHaskell#haskell-core and close the shell to proceed:"
zsh
pacman-key -r 4209170B
pacman-key --lsign-key 4209170B
pacman --noconfirm -Syu
pacman --noconfirm -S haskell-stack-tool

su - $username
stack upgrade  # install stack locally
logout

pacman -R haskell-stack-tool
ln -s /home/$username/.local/bin/stack /usr/sbin/stack
chown $username /home/$username/.local/bin/stack
chmod o+ux /home/$username/.local/bin/stack  # Make sure others can use it


# Interface
su - $username

pacaur -S redshift-minimal
pacman --noconfirm -S termite
pacman --noconfirm -S dmenu
pacman --noconfirm -S xclip
pacman --noconfirm -S numlockx  # utility to turn on numlock
pacman --noconfirm -S feh  # image viewer, shows background
pacaur -S unclutter-xfixes-git  # hides the mouse pointer when not used

# Fonts
pacman --noconfirm -S ttf-dejavu ttf-ubuntu-font-family
pacman --noconfirm -S terminus-font  # looks cool in dmenu
pacman --noconfirm -S ttf-liberation  # used by chrome
pacaur -S powerline-fonts-git  # used by vim airline plugin

# Browser and dropbox
pacaur -S google-chrome
pacaur -S dropbox dropbox-cli

# Setup stack and install xmonad and xmobar
stack setup
stack update
stack install X11-xft xmonad xmonad-contrib xmobar
# If ~/.local/bin/stack exists then you can do
# pacman -R haskell-stack-tool
# ln -s /home/$username/.local/bin/stack /usr/sbin/stack


## User tools
su - $username

# Text editing
pacman --noconfirm -S neovim
pip3 install neovim-remote  # Used with vimtex
pacman --noconfirm -S dos2unix

# PDF
pacman --noconfirm -S zathura zathura-pdf-mupdf zathura-ps
xdg-mime default zathura.desktop application/pdf
pacman --noconfirm -S xdotool  # Required to connect zathura with vim-latex

# Music
pacman --noconfirm -S mpd
pacman --noconfirm -S ncmpc

# Configure mpd (we're using per-user configuration)
export CONF_MPD_MUSICDIR="$HOME/Music"
export CONF_MPD_HOMEDIR="$HOME/.config/mpd"  # TODO: Can we use $XDG_CONFIG_HOME here?
mkdir -p "$CONF_MPD_HOMEDIR/playlists"

cd ~/tmp && git clone https://github.com/ronalde/mpd-configure.git && cd ~/tmp/mpd-configure
echo "Running mpd-configure with default settings, if you are using advanced setup
(like DAC on USB) see https://github.com/ronalde/mpd-configure"
bash mpd-configure -n -o "$HOME/.config/mpd/mpd.conf"

# Add player to dmenu under the name 'mp'
echo "#!/bin/sh
termite -e ncmpc" > ~/.local/bin/mp
chmod +x ~/.local/bin/mp
rm ~/.cache/dmenu_run

# IRC
pacman --noconfirm -S irssi

# Writing
pacman --noconfirm -S texlive-most
pacman --noconfirm -S aspell aspell-en

# Network
pacman --noconfirm -S openvpn
pacman --noconfirm -S net-tools
pacman --noconfirm -S bind-tools

# General programming
pacman --noconfirm -S valgrind
pacman --noconfirm -S lua  # Used by vim plugin Shougo/neocomplete

# Haskell
stack install hlint ghc-mod pointfree pointful

# Python (python already installed in basic.sh)
pip install flake8  # syntax checking for python with syntastic
pip install clf
