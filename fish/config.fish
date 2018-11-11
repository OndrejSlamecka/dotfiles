set fish_greeting (date)

set -gx EDITOR nvim

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
abbr kssh=kitty +kitten ssh

# See functions directory for the following
install_git_abbr
colorman
