#!/bin/sh

source $HOME/.config/path.sh

# Make Java apps work with xmonad
export _JAVA_AWT_WM_NONREPARENTING=1

xrdb -merge $HOME/.Xresources  # X settings
#xset +fp $HOME/.fonts  # X fonts

numlockx &  # Toggle numlock
xkbcomp -I$HOME/dotfiles/xkb $HOME/dotfiles/xkb/cz-prog.xkb $DISPLAY -w 3
# Change some key bindings (this is too subjective to be included in a keyboard layout)
xmodmap ~/.Xmodmap

unclutter &  # Hide mouse when unused

dropbox-cli start & # Start dropbox syncing

xset dpms 0 0 900  # Turn off the display after 15 minutes
redshift &  # Start redshift

feh --bg-scale ~/Dropbox/WP/fuji_purple_fog.jpg  # Set background

exec xmonad
