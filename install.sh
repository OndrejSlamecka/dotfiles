#!/bin/sh

if test "x$XDG_CONFIG_HOME" = "x" ; then
    XDG_CONFIG_HOME=$HOME/.config
fi

## Functions

function make_links () {
    folder=$1
    items=$2

    if [ "$folder" == "$XDG_CONFIG_HOME" ]; then
        prefix=""
    elif [ "$folder" == "$HOME" ]; then
        prefix="."
    else
        echo "ERROR: Wrong \$folder in call to make_links."
        exit 1
    fi

    for item in $items; do
        link_path="$folder/$prefix$item"
        # -L -- is a file AND a symlink, -e -- is a dir or file
        if [ -e $link_path -a ! -L $link_path ]; then
            echo "ERROR, $link_path exists but is not a symlink"
        fi
        if [ ! -e $link_path -a ! -d $link_path ]; then
            ln -s ~/dotfiles/$item $link_path
        fi
    done
}

## RUN

echo "
    _|  _ _|_ _|_ o |  _   _   o ._   _ _|_  _. | |  _  ._
   (_| (_) |_  |  | | (/_ _>   | | | _>  |_ (_| | | (/_ |
"

# Dotfiles in $HOME
dotfiles="xmonad Xresources xkb Xmodmap start-xmonad.sh urxvt fonts"
dotfiles="$dotfiles oh-my-zsh zshrc vimrc"
dotfiles="$dotfiles emacs latexmkrc gitconfig ghci"

echo "Creating symbolic links in $HOME (only if they do not exist)..."
make_links "$HOME" "$dotfiles"


# Dotfiles in $XDG_CONFIG_HOME
configfiles="nvim redshift.conf zathura pacaur termite"
echo "Creating symbolic links in $XDG_CONFIG_HOME (only if they do not exist)..."
make_links "$XDG_CONFIG_HOME" "$configfiles"


# Switch this repo to ssh -- some time after this setup a push may be needed
git remote set-url origin git@github.com:OndrejSlamecka/dotfiles.git


# X setup
echo "Merging .Xresources and clearing font cache..."
xrdb -merge ~/.Xresources
fc-cache ~/.fonts/


# Add cwd-spawn support for ssh connections
echo "Making cwd-spawn work with ssh connections..."
mkdir -p ~/.ssh
if [ ! -f ~/.ssh/config ]; then
    touch ~/.ssh/config
    chmod 600 ~/.ssh/config
fi

sshconfig='Host *
    PermitLocalCommand yes
    LocalCommand ssh_connection_to_urxvt "%r %h %p"'

if ! grep -q 'LocalCommand ssh_connection_to_urxvt "%r %h %p"' ~/.ssh/config; then
    echo "$sshconfig" >> ~/.ssh/config
fi


# Installing nvim plugins
echo "Installing nvim plugins..."

if [ ! -d ~/.config/nvim/dein ]; then
    cd ~/tmp
    curl -s -S https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
    sh ./installer.sh ~/.config/nvim/dein
fi


# Inform the user we are finished
echo "Done!"
