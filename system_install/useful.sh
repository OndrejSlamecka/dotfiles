#!/bin/sh

pacman --quiet --noconfirm --needed -S valgrind

# Python
pip install flake8  # syntax checking for python with syntastic
pip install clf

# TeX
pacman --quiet --noconfirm --needed -S texlive-most
pacman --quiet --noconfirm --needed -S xdotool  # Required to connect zathura with vim-latex

# Writing
pacman --quiet --noconfirm --needed -S aspell aspell-en

# Haskell dev tools
stack install hlint ghc-mod pointfree pointful
