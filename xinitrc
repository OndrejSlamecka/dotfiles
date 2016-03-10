#!/bin/sh

if test "x$XDG_CONFIG_HOME" = "x"; then
    XDG_CONFIG_HOME=$HOME/.config
    export XDG_CONFIG_HOME
fi

xrdb -merge ~/.Xresources  # X settings
xset +fp ~/.fonts/  # X fonts

numlockx &  # Toggle numlock
xmodmap ~/.Xmodmap  # Change some key bindings
unclutter &  # Hide mouse when unused

[ ! -s ~/.mpd/pid ] && mpd  # Music player daemon
dropbox-cli start  # Start dropbox syncing
redshift &  # Start redshift

feh --bg-scale ~/Dropbox/WP/nebula.jpg
xautolock -t 10 -locker slock  # Lock screen after 10 inactive minutes
stack exec xmonad

