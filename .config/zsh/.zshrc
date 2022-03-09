# For managing dot files
alias .git='/usr/bin/git --git-dir $HOME/.dotfilegit --work-tree $HOME'

# Useful git stuff
alias gs='git status'
alias ga='git add'
alias gp='git push'
alias gpo='git push origin'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias gr='git branch -r'
alias gplo='git pull origin'
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gco='git checkout '
alias gl='git log'
alias gr='git remote'
alias grs='git remote show'
alias glo='git log --pretty="oneline"'
alias glol='git log --graph --oneline --decorate'

# History options
setopt HIST_SAVE_NO_DUPS

autoload -U compinit; compinit
_comp_options+=(globdots)

fpath=("$ZDOTDIR/prompts" $fpath)
autoload -Uz purification; purification

