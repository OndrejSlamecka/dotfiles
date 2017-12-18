#!/bin/sh

if [ -z "$username" ]; then
    echo 'Set the `username` variable'
    exit 1
fi

# Setup folders and dotfiles
mkdir -p $HOME/tmp $HOME/.config $HOME/.local/bin $HOME/.cache
mkdir -p $HOME/Music

rm -f $HOME/.zshrc # dotfiles have one, the current one is prob. empty
git clone https://github.com/OndrejSlamecka/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles && sh install.sh

## AUR helper
buildroot="$(mktemp -d)"
mkdir -p "$buildroot" && cd "$buildroot"

# Add author's GPG key
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53

git clone "https://aur.archlinux.org/trizen.git"
cd "${buildroot}/trizen" && makepkg --syncdeps --install --noconfirm
cd "$HOME" && rm -rf "$buildroot"

trizen -Syu --aur

# AUR packages
trizen --noconfirm --needed -S libtinfo  # Needed for Haskell Stack
trizen --noconfirm --needed -S redshift-minimal
trizen --noconfirm --needed -S unclutter-xfixes-git  # hides the mouse pointer when not used
trizen --noconfirm --needed -S powerline-fonts-git  # used by vim airline plugin
trizen --noconfirm --needed -S google-chrome
trizen --noconfirm --needed -S dropbox dropbox-cli


## Configure mpd (we're using per-user configuration)
export CONF_MPD_MUSICDIR="$HOME/Music"
export CONF_MPD_HOMEDIR="$HOME/.config/mpd"  # TODO: Can we use $XDG_CONFIG_HOME here?
mkdir -p "$CONF_MPD_HOMEDIR/playlists"

cd ~/tmp && git clone https://github.com/ronalde/mpd-configure.git && cd ~/tmp/mpd-configure
# TODO: Add pulseaudio
echo "Running mpd-configure with default settings, if you are using advanced setup
(like DAC on USB) see https://github.com/ronalde/mpd-configure"
bash mpd-configure -n -o "$HOME/.config/mpd/mpd.conf"

# Add player to dmenu under the name 'mp'
echo "#!/bin/sh
termite -e ncmpc" > $HOME/.local/bin/mp
chmod +x ~/.local/bin/mp
rm ~/.cache/dmenu_run

## Haskell
sudo sed -i '/\[community\]/i\
[haskell-core]\
Server = http:\/\/xsounds.org\/~haskell\/core\/$arch\
' /etc/pacman.conf

sudo pacman-key -r 4209170B
sudo pacman-key --lsign-key 4209170B
sudo pacman --quiet --noconfirm --needed -Syu
sudo pacman --quiet --noconfirm --needed -S haskell-stack-tool

# Setup stack
sudo ln -s /usr/lib/libtinfo.so /usr/lib/libtinfo.so.5
stack upgrade
stack setup
stack update

# xmonad
cd ~/.xmonad && make

# xmobar
stack install X11-xft xmobar --flag xmobar:with_xft

# Haskell dev tools
stack install hlint ghc-mod pointfree pointful
