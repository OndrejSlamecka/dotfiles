ZSH=$XDG_CONFIG_HOME/zsh

## PATH
export PATH=$PATH:$HOME/.local/bin


## Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi


## Completion settingsa, see ZSH/lib/completion.zsh
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"


## VCS, see ZSH/lib/git.zsh
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


## Plugins
plugins=(git git-extras ssh-agent)

#- Loading
# All plugins have to be in fpath before running compinit.
for plugin ($plugins); do
    fpath=($ZSH/plugins/$plugin $fpath)
done

autoload -U compinit
compinit -d "$XDG_CACHE_DIR/zcompdump"

for plugin ($plugins); do
    source $ZSH/plugins/$plugin/$plugin.plugin.zsh
done


## Other configuration files
for config_file ($ZSH/lib/*.zsh); do
  source $config_file
done


## Theme
source "$ZSH/themes/dracula.zsh-theme"
