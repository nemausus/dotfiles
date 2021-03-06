# .zshrc
# Load global definitions
[ -f /etc/zshrc ] && . /etc/zshrc

# Load work stuff (Don't upload this to github repo)
[ -f ~/.zshrc.work ] && . ~/.zshrc.work

# Load from shrc
source ~/dotfiles/shrc

# Don't put duplicate lines in history
setopt HIST_IGNORE_DUPS
# Append to the history file, don't overwrite it
setopt APPEND_HISTORY

# Allow tab completion in the middle of a word.
setopt COMPLETE_IN_WORD

setopt PROMPT_SUBST
PROMPT='%F{green}%n%f:%2~% %F{yellow} $(git_branch)$(hg_bookmark) %f$ '

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
