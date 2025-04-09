#!/bin/sh
cd "$HOME"
if [ ! -d "$HOME/dotfiles" ]; then
    echo "Setting up dotfiles"
    git clone https://github.com/nemausus/dotfiles.git
else
    echo "dotfiles already present"
fi

# Setup all symlinks
ln -sf dotfiles/bashrc .bashrc
ln -sf dotfiles/bashrc .zshrc
ln -sf dotfiles/vimrc .vimrc
ln -sf dotfiles/tmux.conf .tmux.conf
ln -sf dotfiles/gitconfig .gitconfig
# ln -sf dotfiles/ycm_extra_conf.py .ycm_extra_conf.py

if [ "$(uname)" = "Darwin" ]; then
  echo "Setting up Mac"
  # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install git vim cmake tmux scons wget maven git-lfs ripgrep
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
  if [ "$(cat /etc/os-release | head -1 | cut -b 7-12)" = "Ubuntu" ]; then
    echo "Setting up Ubuntu"
    sudo apt-get -y install git vim cmake tmux scons wget
  elif [ "$(cat /etc/os-release | head -1 | cut -b 7-12)" = "CentOS" ]; then
    echo "Setting up CentOS"
    sudo yum install git vim cmake tmux scons wget
  fi
fi

# Clone vundle
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
# Install vim plugins
vim +PluginInstall +qall
# Setup ycm plugin
# cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer
