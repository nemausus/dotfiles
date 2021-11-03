# .bashrc
# bashrc is for aliases, functions, and shell configuration intended for use in
# interactive shells.  However, in some circumstances, bash sources bashrc even
# in non-interactive shells (e.g., when using scp), so it is standard practice
# to check for interactivity at the top of .bashrc and return immediately if
# the shell is not interactive.  The following line does that; don't remove it!
if [[ $SHELL = */zsh ]]; then
  [[ ! -o interactive ]] && return
  # Load global definitions
  [ -f /etc/zshrc ] && . /etc/zshrc;
else
  [[ $- != *i* ]] && return
  # Load global definitions
  [ -f /etc/bash.bashrc ] && . /etc/bash.bashrc
  [ -f /etc/bashrc ] && . /etc/bashrc
  # Load bash completion.
  [ -f /etc/bash_completion ] && . /etc/bash_completion
  [[ $(uname -s) = "Darwin" ]] && [ -f $(brew --prefix)/etc/bash_completion ] && . $(brew --prefix)/etc/bash_completion;
fi

# Load work stuff (Don't upload this to github repo)
[ -f ~/.bashrc.work ] && . ~/.bashrc.work

# Don't limit the size of the history file
HISTFILESIZE=1000000
SAVEHIST=1000000
# Sets the limit of the in-memory history list to 1 million
HISTSIZE=1000000
# Append new commands to the history file every time it displays a prompt
# (i.e., after every command finishes). Without this, appending won't happen
# until Bash exits.
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Set colors
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
BLACK="\[\033[0;30m\]"
BLUE="\[\033[0;34m\]"
CYAN="\[\033[0;36m\]"
PURPLE="\[\033[0;35m\]"
NO_COLOUR="\[\033[0m\]"


if [[ $SHELL = */zsh ]]; then
  # Don't put duplicate lines in history
  setopt HIST_IGNORE_DUPS
  # Append to the history file, don't overwrite it
  setopt APPEND_HISTORY
  # Allow tab completion in the middle of a word.
  setopt COMPLETE_IN_WORD
  # Customize shell prompt
  setopt PROMPT_SUBST
  PROMPT='%F{green}%n%f:%2~% %F{yellow} $(git_branch)$(hg_bookmark) %f$ '
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh;
else
  # Don't put duplicate lines in history
  HISTCONTROL=ignoredups
  # Append to the history file, don't overwrite it
  shopt -s histappend
  # Check the window size after each command and, if necessary,
  # update the values of LINES and COLUMNS.
  shopt -s checkwinsize
  # Customize shell prompt
  PS1="$GREEN\u$NO_COLOUR:\W$YELLOW \$(git_branch)\$(hg_bookmark) $NO_COLOUR$ "
  [ -f ~/.fzf.bash ] && source ~/.fzf.bash;
fi

############################ BEGIN FUNCTIONS ###################################
# Returns current git branch.
function git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# Returns current hg bookmark.
function hg_bookmark () {
  hg bookmarks 2> /dev/null | sed -e "s/^[ \t]*//" -e '/^[^*]/d' -e 's/* \([a-zA-Z0-9_-]*\)[ ]*.*/\1/'
}

# Finds comma seperated file extensions.
#   Usage: exfind folly,common cpp,h,thrift
function exfind () {
  DIRS=$(echo $1 | sed -e "s/,/ /g")
  FILES=$(echo $2 | sed -e "s/,/|/g")
  CMD='find'
  if [ -d .git ]; then
    CMD='git ls-files';
  fi;
  $CMD $DIRS | grep -E "\.($FILES)\$"
}

# Generates ctags.
#   Usage: exfind folly,common cpp,h,thrift | genctags
function genctags () {
  ctags --c++-kinds=+p --extras=+q -L -
}

# Makes new Dir and jumps inside.
function mcd () {
  mkdir -p "$1" && cd "$1"
}

# Rebases current branch on top of given branch
#   Usage: rebase master
function rebase () {
  branch=$(git_branch)
  git co $1
  git pull origin $1 --rebase
  git co $branch
  git rebase $1
}

function extract () {
  case $1 in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.tar.xz) tar Jxvf "$1" ;;
    *.tar.Z) tar xzf "$1" ;;
    *.tar) tar xf "$1" ;;
    *.taz) tar xzf "$1" ;;
    *.tb2) tar xjf "$1" ;;
    *.tbz) tar xjf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.txz) tar Jxvf "$1" ;;
    *.zip) unzip "$1" ;;
    *.gz) gunzip "$1" ;;
    *) echo "'$1' cannot be extracted" ;;
  esac
}

################################## ALIASES ####################################
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias hglog='hg log --template "\x1B[31m {node|short} \x1B[33m {date|age} \x1B[0m {phabdiff} {desc|firstline} \x1B[32m {author|user} \x1B[0m\n"'
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias ....='cd ../../../'                   # Go back 3 directory levels
alias .....='cd ../../../../'               # Go back 4 directory levels
alias ......='cd ../../../../../'           # Go back 5 directory levels


################################## EXPORTS ####################################
# Set vim as default editor.
export EDITOR=vim
export GIT_EDITOR=vim
export VISUAL=vim

# Add bin to PATH
export PATH=$HOME/rtags/bin:$PATH
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$MAVEN_HOME/bin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/usr/local/bin:$PATH
export NVM_DIR="~/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
export NODE_PATH='/usr/local/lib/jsctags:${NODE_PATH}'

# Load linux only configs
if [[ $(uname -s) = "Linux" ]]; then
  # http://www.linuxjournal.com/content/globstar-new-bash-globbing-option
  # recurse directory when ** is used in commands.
  shopt -s globstar
  export TERM=xterm-256color

  # enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      alias ls='ls --color=auto'
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto';
  fi;
fi

# Load mac only configs
if [ $(uname -s) = "Darwin" ]; then
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home"
  export CLICOLOR=1
fi
