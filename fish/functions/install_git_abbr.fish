function install_git_abbr
    # Git -- https://gist.github.com/sonukapoor/3bd3268b948659d26540811c1491d5bb
    abbr --add g 'git'
    abbr --add gst 'git status'
    abbr --add gd 'git diff'
    abbr --add gdc 'git diff --cached'
    abbr --add gg 'git pull'
    abbr --add gup 'git pull --rebase'
    abbr --add gp 'git push'
    abbr --add gf 'git push --force'
    abbr --add gd 'git diff'
    abbr --add gl 'git log'

    abbr --add gr 'git rebase -i (git merge-base HEAD origin/master)'
    abbr --add grc 'git rebase --continue'
    abbr --add gra 'git rebase --abort'

    function gdv
      git diff -w $argv | view -
    end

    abbr --add gc 'git commit -v'
    abbr --add gc! 'git commit -v --amend'
    abbr --add gca 'git commit -v -a'
    abbr --add gca! 'git commit -v -a --amend'
    abbr --add gcmsg 'git commit -m'
    abbr --add gco 'git checkout'
    abbr --add gcm 'git checkout master'
    abbr --add gcb 'git checkout -b'
    abbr --add gb 'git branch'
    abbr --add gba 'git branch -a'
    abbr --add gcount 'git shortlog -sn'
    abbr --add gs 'git status'
    abbr --add ga 'git add'
    abbr --add gwc 'git whatchanged -p --abbrev-commit --pretty=medium'
    abbr --add gcp 'git cherry-pick'

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

    abbr --add ggpull 'git pull origin (current_branch)'
    abbr --add ggpur 'git pull --rebase origin (current_branch)'
    abbr --add ggpush 'git push origin (current_branch)'
    abbr --add ggpnp 'git pull origin (current_branch); and git push origin (current_branch)'
end
