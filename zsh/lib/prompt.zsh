PS1="%n@%m:%~%# "

ZSH_THEME_GIT_PROMPT_PREFIX="git:(" # Prefix at the very beginning of the prompt
ZSH_THEME_GIT_PROMPT_SUFFIX=")"     # At the very end of the prompt
ZSH_THEME_GIT_PROMPT_DIRTY="*"      # Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_CLEAN=""       # Text to display if the branch is clean

autoload -U colors && colors
setopt auto_cd # If you type foo, and it isn't a command,
               # and it is a directory in your cdpath, go there
setopt multios # perform implicit tees or cats when multiple
               # redirections are attempted
setopt prompt_subst # Enable parameter expansion, command substitution,
                    # and arithmetic expansion in the prompt
setopt long_list_jobs # List jobs in the long format by default.
setopt interactivecomments # Allow comments even in interactive shells
