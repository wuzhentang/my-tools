
# auto install vim configs
if [ ! -f ~/.vim_runtime/install_awesome_vimrc.sh ];then
    rm -rf ~/.vim_runtime
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
    ln -s "$CURRENT_PATH/configs/vim/vim.vim"  ~/.vim_runtime/my_configs.vim
fi
