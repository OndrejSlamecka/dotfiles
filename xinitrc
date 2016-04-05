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

feh --bg-scale ~/Dropbox/WP/nebula.jpg  # Set background

xset dpms 0 0 900  # Turn off the display after 15 minutes

# xset s 600  # 10 minutes to lock the screen
# xss-lock slock &

# Alternatively use dimming (the dim-screen script needs configuration)
# xset s 300 300  # 300 seconds to dim, next 300 to lock
# xss-lock -n 'sh /usr/share/doc/xss-lock/dim-screen.sh' -- slock &

stack exec xmonad
