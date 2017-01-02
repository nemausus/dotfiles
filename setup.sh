cd ~/
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
