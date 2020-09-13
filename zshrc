# .zshrc
# Load global definitions
[ -f /etc/zshrc ] && . /etc/zshrc

# Load work stuff (Don't upload this to github repo)
[ -f ~/.zshrc.work ] && . ~/.zshrc.work

# Load from shrc
source ~/dotfiles/shrc

setopt prompt_subst
PROMPT='%F{green}%n%f:%2~% %F{yellow} $(git_branch)$(hg_bookmark) %f$ '

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
