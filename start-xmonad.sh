#!/bin/sh

source $HOME/.config/path.sh

# Make Java apps work with xmonad
export _JAVA_AWT_WM_NONREPARENTING=1

xrandr --output DVI-D-1 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-0 --mode 2560x1440 --pos 1920x0 --rotate normal --dpi 221 --output DVI-D-0 --mode 1920x1080 --pos 4480x0 --rotate left

#xrdb -merge $HOME/.Xresources  # X settings
#xset +fp $HOME/.fonts  # X fonts

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
numlockx &  # Toggle numlock
#xkbcomp -I$HOME/dotfiles/xkb $HOME/dotfiles/xkb/cz-prog.xkb $DISPLAY -w 3
# Change some key bindings
xmodmap ~/dotfiles/Xmodmap
xbindkeys -f ~/dotfiles/xbindkeysrc

unclutter &  # Hide mouse when unused

xset r rate 200 40 # delay, rate per second

xset dpms 0 0 900  # Turn off the display after 15 minutes
redshift &  # Start redshift
dunst &  # Notification daemon
light-locker &  # Screen locking integrated with LightDM

feh --bg-fill ~/dotfiles/wallpaper.jpg

exec -- ssh-agent xmonad
