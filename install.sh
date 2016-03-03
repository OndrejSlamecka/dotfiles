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
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall

# - vim: finish vimproc installation
cd ~/.vim/bundle/vimproc.vim
make

# - vim: haskell syntax highlighting
if [ ! -f ~/.vim/syntax/haskell.vim ]; then
    mkdir -p ~/.vim/syntax && cd ~/.vim/syntax
    wget -nv https://raw.githubusercontent.com/sdiehl/haskell-vim-proto/master/vim/syntax/haskell.vim
    wget -nv https://raw.githubusercontent.com/sdiehl/haskell-vim-proto/master/vim/syntax/cabal.vim
    mkdir -p ~/.vim/snippets && cd ~/.vim/snippets
    wget -nv https://github.com/sdiehl/haskell-vim-proto/raw/master/vim/snippets/haskell.snippets
fi


# Inform the user we are finished
echo "Done!"
