#!/bin/sh

echo "
    _|  _ _|_ _|_ o |  _   _   o ._   _ _|_  _. | |  _  ._
   (_| (_) |_  |  | | (/_ _>   | | | _>  |_ (_| | | (/_ |
"

dotfiles="xmonad xinitrc oh-my-zsh zshrc vim vimrc latexmkrc gitconfig Xresources emacs urxvt fonts"

echo "Creating symbolic links (only if they do not exist)..."
for file in $dotfiles; do
    # -L -- is a file AND a symlink
    if [ -f ~/.$file -a ! -L ~/.$file ]; then
        echo "ERROR, file ~/.$file exists but is not a symlink"
    fi
    if [ ! -f ~/.$file -a ! -d ~/.$file ]; then
        ln -s ~/dotfiles/$file ~/.$file
    fi
done

# Misc setup
echo "Merging .Xresources and clearing font cache..."
xrdb -merge ~/.Xresources
fc-cache ~/.fonts/

# Add cwd-spawn support for ssh connections
echo "Making cwd-spawn work with ssh connections..."
sshconfig='Host *
    PermitLocalCommand yes
    LocalCommand ssh_connection_to_urxvt "%r %h %p"'

if ! grep -q 'LocalCommand ssh_connection_to_urxvt "%r %h %p"' ~/.ssh/config; then
    echo "$sshconfig" >> ~/.ssh/config
fi

# Inform the user we are finished
echo "Done!"
