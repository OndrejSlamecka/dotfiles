#!/bin/bash

# https://github.com/mlopes/dotfiles/blob/master/.xmonad/bin/volume.sh

# Get L/R volume info
left=$(amixer sget Master | grep Left:)
right=$(amixer sget Master | grep Right:)
llevel=${left#*[}
llevel=${llevel%\%]*}
rlevel=${right#*[}
rlevel=${rlevel%\%]*}
active=${left##*[}
active=${active%]}

# Find average level
if [ $llevel == $rlevel ]
then
    level=$llevel
else
    level=$(($llevel + $rlevel))
    level=$(($level / 2))
fi

# Create displays
if [ $active == "off" ] || [ $level == "0" ]
then
    echo "<fn=1></fn>  "
elif [ "$level" -gt "50" ]
then
    echo "$level%  <fn=1></fn>"
else
    echo "$level%  <fn=1></fn> "
fi
