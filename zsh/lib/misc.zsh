ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
alias xclipb="xclip -selection clipboard"

# Enable opening a new terminal in the same directory with termite
if [ -f /etc/profile.d/vte.sh ]; then
    source /etc/profile.d/vte.sh
fi
