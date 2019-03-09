cd ~/
if [ "$(uname)" == "Darwin" ]; then
  echo "Setting up Mac"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install git
  brew install vim
  brew install cmake
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  if [ "$(cat /etc/os-release | head -1 | cut -b 7-12)" == "Ubuntu" ]; then
    echo "Setting up Ubuntu"
    sudo apt-get install git vim cmake
  elif [ "$(cat /etc/os-release | head -1 | cut -b 7-12)" == "CentOS" ]; then
    echo "Setting up CentOS"
    sudo yum install git vim cmake
  fi
fi

git clone https://github.com/nemausus/dotfiles.git

# setup all symlinks
ln -sf dotfiles/bashrc .bashrc
ln -sf dotfiles/vimrc .vimrc
ln -sf dotfiles/tmux.conf .tmux.conf
ln -sf dotfiles/gitconfig .gitconfig
ln -sf dotfiles/ycm_extra_conf.py .ycm_extra_conf.py

# clone vundle 
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# run :PluginInstall to setup vim plugins.
# setup ycm plugin after installing vim plugins.
# cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer
