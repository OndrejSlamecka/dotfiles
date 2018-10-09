function install_git_abbr
    # Git -- https://gist.github.com/sonukapoor/3bd3268b948659d26540811c1491d5bb
    abbr g='git'
    abbr gst='git status'
    abbr gd='git diff'
    abbr gdc='git diff --cached'
    abbr gg='git pull'
    abbr gup='git pull --rebase'
    abbr gp='git push'
    abbr gf='git push --force'
    abbr gd='git diff'
    abbr gl='git log'

    abbr gr='git rebase -i (git merge-base HEAD origin/master)'
    abbr grc='git rebase --continue'
    abbr gra='git rebase --abort'

    function gdv
      git diff -w $argv | view -
    end

    abbr gc='git commit -v'
    abbr gc!='git commit -v --amend'
    abbr gca='git commit -v -a'
    abbr gca!='git commit -v -a --amend'
    abbr gcmsg='git commit -m'
    abbr gco='git checkout'
    abbr gcm='git checkout master'
    abbr gcb='git checkout -b'
    abbr gb='git branch'
    abbr gba='git branch -a'
    abbr gcount='git shortlog -sn'
    abbr gs='git status'
    abbr ga='git add'
    abbr gwc='git whatchanged -p --abbrev-commit --pretty=medium'

    # Will cd into the top of the current repository or submodule.
    alias grt='cd (git rev-parse --show-toplevel or echo ".")'

    # Will return the current branch name, e.g., git pull origin (current_branch)
    function current_branch
      set ref (git symbolic-ref HEAD 2> /dev/null); or \
      set ref (git rev-parse --short HEAD 2> /dev/null); or return
      echo ref | sed s-refs/heads--
    end

    function current_repository
      set ref (git symbolic-ref HEAD 2> /dev/null); or \
      set ref (git rev-parse --short HEAD 2> /dev/null); or return
      echo (git remote -v | cut -d':' -f 2)
    end

    abbr ggpull='git pull origin (current_branch)'
    abbr ggpur='git pull --rebase origin (current_branch)'
    abbr ggpush='git push origin (current_branch)'
    abbr ggpnp='git pull origin (current_branch); and git push origin (current_branch)'
end
