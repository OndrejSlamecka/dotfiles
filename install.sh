#!/bin/sh

echo "
    _|  _ _|_ _|_ o |  _   _   o ._   _ _|_  _. | |  _  ._
   (_| (_) |_  |  | | (/_ _>   | | | _>  |_ (_| | | (/_ |
"

dotfiles="xmonad Xresources Xmodmap xinitrc urxvt fonts"
dotfiles="$dotfiles oh-my-zsh zshrc vim vimrc"
dotfiles="$dotfiles emacs latexmkrc gitconfig ghci"

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


# Installing vim plugins
echo "Installing vim plugins..."

if [ ! -d ~/.vim/dein ]; then
    cd ~/tmp
    wget https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
    sh ./installer.sh ~/.vim/dein
fi


# Inform the user we are finished
echo "Done!"
