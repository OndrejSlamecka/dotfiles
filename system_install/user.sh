#!/bin/sh

if [ -z "$username" ]; then
    echo 'Set the `username` variable'
    exit 1
fi

# Setup folders and dotfiles
mkdir -p $HOME/tmp $HOME/.config $HOME/.local/bin $HOME/.cache $HOME/Music

git clone https://github.com/OndrejSlamecka/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles && sh install.sh

## AUR helper
buildroot="$(mktemp -d)"
git clone "https://aur.archlinux.org/pikaur.git" "$buildroot"
cd "pikaur" && makepkg --noconfirm --force --syncdeps --rmdeps --install
cd "$HOME" && rm -rf "$buildroot"
pikaur -Syu --aur

# AUR packages
gpg --recv-keys EB4F9E5A60D32232BB52150C12C87A28FEAC6B20 # browserpass's maintainer's

pikaur --noconfirm --needed -S \
    redshift-minimal \
    unclutter-xfixes-git \
    powerline-fonts-git \
    keybase-bin \
    ttf-font-awesome \
    stack-bin

# Setup stack
stack upgrade
stack setup
stack update
pikaur -R stack-bin # Now we have $HOME/.local/bin/stack and do not need the Arch one

# Desktop environment
cd ~/.xmonad && make
stack install X11-xft xmobar --flag xmobar:with_xft

# Setup keybase
keybase login ondrejslamecka

# Setup pass -- TODO: this obviously needs to auth with gitlab. Where do
# we make ssh keys in this setup?
git clone git@gitlab.com:OndrejSlamecka/pass.git ~/.password-store

## Configure mpd (we're using per-user configuration)
export CONF_MPD_MUSICDIR="$HOME/Music"
export CONF_MPD_HOMEDIR="$HOME/.config/mpd"  # TODO: Can we use $XDG_CONFIG_HOME here?
mkdir -p "$CONF_MPD_HOMEDIR/playlists"

cd ~/tmp && git clone https://github.com/ronalde/mpd-configure.git && cd ~/tmp/mpd-configure
bash mpd-configure -n -o "$HOME/.config/mpd/mpd.conf"
systemctl enable "mpd.service"
