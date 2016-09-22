#!/bin/sh

if test "x$XDG_CONFIG_HOME" = "x"; then
    XDG_CONFIG_HOME=$HOME/.config
    export XDG_CONFIG_HOME
fi

devmon &

xrdb -merge ~/.Xresources  # X settings
xset +fp ~/.fonts/  # X fonts

numlockx &  # Toggle numlock
xkbcomp -I$HOME/dotfiles/xkb $HOME/dotfiles/xkb/cz-prog.xkb $DISPLAY -w 3
# Change some key bindings (this is too subjective to be included in a keyboard layout)
xmodmap ~/.Xmodmap

unclutter &  # Hide mouse when unused

[ ! -s ~/.mpd/pid ] && mpd  # Music player daemon
dropbox-cli start  # Start dropbox syncing

xset dpms 0 0 900  # Turn off the display after 15 minutes
redshift &  # Start redshift

feh --bg-scale ~/Dropbox/WP/fuji_purple_fog.jpg  # Set background

stack exec xmonad
