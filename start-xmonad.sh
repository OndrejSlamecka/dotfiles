#!/bin/sh

source $HOME/.config/path.sh

# Make Java apps work with xmonad
export _JAVA_AWT_WM_NONREPARENTING=1

#xrdb -merge $HOME/.Xresources  # X settings
#xset +fp $HOME/.fonts  # X fonts

numlockx &  # Toggle numlock
#xkbcomp -I$HOME/dotfiles/xkb $HOME/dotfiles/xkb/cz-prog.xkb $DISPLAY -w 3
# Change some key bindings
xmodmap ~/dotfiles/Xmodmap

unclutter &  # Hide mouse when unused


xset dpms 0 0 900  # Turn off the display after 15 minutes
redshift &  # Start redshift

feh --bg-fill ~/dotfiles/wallpaper.jpg

exec -- ssh-agent xmonad
