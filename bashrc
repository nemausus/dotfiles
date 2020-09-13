# .bashrc
# bashrc is for aliases, functions, and shell configuration intended for use in
# interactive shells.  However, in some circumstances, bash sources bashrc even
# in non-interactive shells (e.g., when using scp), so it is standard practice
# to check for interactivity at the top of .bashrc and return immediately if
# the shell is not interactive.  The following line does that; don't remove it!
[[ $- != *i* ]] && return

# Load global definitions
[ -f /etc/bash.bashrc ] && . /etc/bash.bashrc
[ -f /etc/bashrc ] && . /etc/bashrc

# Load work stuff (Don't upload this to github repo)
[ -f ~/.bashrc.work ] && . ~/.bashrc.work

# Load bash completion.
[ -f /etc/bash_completion ] && . /etc/bash_completion

# Load from shrc
source ~/dotfiles/shrc

# Don't put duplicate lines in history
HISTCONTROL=ignoredups
# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# bash completion.
[[ $(uname -s) = "Darwin" ]] && [ -f $(brew --prefix)/etc/bash_completion ] && . $(brew --prefix)/etc/bash_completion

# Customize shell prompt
PS1="$GREEN\u$NO_COLOUR:\W$YELLOW \$(git_branch)\$(hg_bookmark) $NO_COLOUR$ "

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
