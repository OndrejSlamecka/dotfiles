#!/bin/sh
# Edit Exec in /usr/share/xsessions/xmonad.desktop to point to this file

numlockx &
xset +fp ~/.fonts/
fbsetbg -f ~/Pictures/space-2.jpg
xmonad > ~/.xmonad/xmonad.log

