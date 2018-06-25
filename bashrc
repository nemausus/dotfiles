# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source global definitions
[ -f /etc/bash.bashrc ] && . /etc/bash.bashrc

# Source bash completion.
[ -f /etc/bash_completion ] && . /etc/bash_completion

# Source linux configs
[[ $(uname -s) == "Linux" ]] && . ~/dotfiles/bashrc_linux

# Source mac configs
[[ $(uname -s) == "Darwin" ]] && . ~/dotfiles/bashrc_mac

# Source work configs
[ -f ~/.bashrc_ts ] && . ~/.bashrc_ts

# Source alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

[ -f ~/.bash_aliases ] && . ~/.bash_aliases

############################ BEGIN FUNCTIONS ###################################
# Returns current git branch.
function git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# Returns current hg bookmark.
function hg_bookmark () {
  hg bookmarks 2> /dev/null | sed -e "s/^[ \t]*//" -e '/^[^*]/d' -e 's/* \([a-zA-Z0-9_-]*\)[ ]*.*/ (\1)/'
}

# Finds comma seperated file extensions.
function exfind () {
  cmd="find ."
  for i in $(echo $@ | tr "," "\n")
  do
    cmd=$cmd' -name '*.$i' -o'
  done
  cmd=$(echo $cmd | sed s/..$//)
  $cmd
}

# Generates ctags.
function genctags () {
  exfind $1 | ctags --extras=+q -L -
}

# Generates ctags and cscope tags.
function genalltags () {
  genctags $1
  exfind $1 > /tmp/c.files
  cscope -b -q -k -i /tmp/c.files
}

# Makes new Dir and jumps inside.
function mcd () { 
  mkdir -p "$1" && cd "$1";
}

function sopt () {
  cd ~/thoughtspot
  scons mode=opt -j24 $@
  cd -
}

function sdbg () {
  scons mode=dbg -j24 $@
}

function stest () {
  cd ~/thoughtspot
  scons runtests=default -j24 $@
  cd -
}

function rebase () {
  branch=$(git_branch)
  git co $1
  git pull --rebase
  git co $branch
  git rebase $1
}

function gitpull () {
  git co master
  git pull --rebase
  git fetch -p
  git branch | grep -v "master" | xargs git branch -D
  git co origin/$1
  git co -b $1
}

function gitpush () {
  ssh naresh@devbox -t "cd thoughtspot && git checkout master"
  git push origin $1 -f
  ssh naresh@devbox -t "cd thoughtspot && git checkout $1"
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
############################## END FUNCTIONS ###################################


# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# Append to the history file, don't overwrite it
shopt -s histappend
# Try to never forget history
HISTSIZE=5000000
HISTFILESIZE=5000000
# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Set colors
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
BLACK="\[\033[0;30m\]"
BLUE="\[\033[0;34m\]"
CYAN="\[\033[0;36m\]"
PURPLE="\[\033[0;35m\]"
NO_COLOUR="\[\033[0m\]"

# Customize shell prompt
PS1="$GREEN\u$NO_COLOUR:\w$YELLOW \$(git_branch)\$(hg_bookmark) $NO_COLOUR$ "


################################## ALIASES ####################################
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias hglog='hg log --template "\x1B[31m {node|short} \x1B[33m {date|age} \x1B[0m {desc|firstline} \x1B[32m {author|user} \x1B[0m\n"'
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

export CPP_FILES="c,h,cpp,hpp,cc,hh,proto,thrift"
export WEB_FILES="php,css,html,js"

# Add bin to PATH
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$MAVEN_HOME/bin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export NVM_DIR="~/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
export NODE_PATH='/usr/local/lib/jsctags:${NODE_PATH}'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/naresh.kumar/Downloads/google-cloud-sdk/path.bash.inc' ]; then source '/Users/naresh.kumar/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/naresh.kumar/Downloads/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/naresh.kumar/Downloads/google-cloud-sdk/completion.bash.inc'; fi
