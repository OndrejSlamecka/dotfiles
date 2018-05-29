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

systemctl enable "mpd.service"

# Create a runner for a player under the name 'mp'
echo "#!/bin/sh
termite -e ncmpc" > $HOME/.local/bin/mp
chmod +x ~/.local/bin/mp

# Add device monitor for auto-mounting
systemctl enable --now "devmon@$username.service"
sudo echo 'polkit.addRule(function(action, subject) {
  var YES = polkit.Result.YES;
  // NOTE: there must be a comma at the end of each line except for the last:
  var permission = {
    // required for udisks1:
    "org.freedesktop.udisks.filesystem-mount": YES,
    "org.freedesktop.udisks.luks-unlock": YES,
    "org.freedesktop.udisks.drive-eject": YES,
    "org.freedesktop.udisks.drive-detach": YES,
    // required for udisks2:
    "org.freedesktop.udisks2.filesystem-mount": YES,
    "org.freedesktop.udisks2.encrypted-unlock": YES,
    "org.freedesktop.udisks2.eject-media": YES,
    "org.freedesktop.udisks2.power-off-drive": YES,
    // required for udisks2 if using udiskie from another seat (e.g. systemd):
    "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
    "org.freedesktop.udisks2.filesystem-unmount-others": YES,
    "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
    "org.freedesktop.udisks2.eject-media-other-seat": YES,
    "org.freedesktop.udisks2.power-off-drive-other-seat": YES
  };
  if (subject.isInGroup("storage")) {
    return permission[action.id];
  }
});' > /etc/polkit-1/rules.d/50-udiskie.rules

## Haskell
trizen --quiet --noconfirm --needed -S stack-bin

# Setup stack
sudo ln -s /usr/lib/libtinfo.so /usr/lib/libtinfo.so.5
stack upgrade
stack setup
stack update

# Now we have $HOME/.local/bin/stack and do not need the Arch one
trizen -R stack-bin

# xmonad
cd ~/.xmonad && make

# xmobar
stack install X11-xft xmobar --flag xmobar:with_xft

# Haskell dev tools
stack install hlint ghc-mod pointfree pointful
