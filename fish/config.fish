set fish_greeting (date)

set -gx EDITOR nvim
set -gx SUDO_ASKPASS /usr/lib/ssh/x11-ssh-askpass

function fish_user_key_bindings
	fzf_key_bindings

    # See functions directory for the following
    bind \e\e sudope
    bind . expand_dots
end

function take --argument-names 'dirname'
    command mkdir $dirname; and cd $dirname
end

kitty + complete setup fish | source
abbr --add kssh 'kitty +kitten ssh'
abbr --add v nvim

# See functions directory for the following
install_git_abbr
colorman
