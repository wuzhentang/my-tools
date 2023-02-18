#!/bin/bash

#get install command
installCmd() {
    echo "install $@ ..."
    if [ "$(uname)" = "Darwin" ]; then
        brew install $@
    elif [ "$(uname)" = "Linux" ]; then
        sudo apt install -y $@
    fi
}

# install base tools
if [ ! -x "$(command -v curl)" ];then
    installCmd curl
fi
if [ ! -x "$(command -v git)" ];then
    installCmd git
fi

#setup zsh
if [ ! -x "$(command -v zsh)" ];then
    installCmd zsh
    #setup zsh as default shell
    echo "use zsh as default shell"
    chsh -s /bin/zsh
fi
#install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ];then
    echo "install oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
#install oh-my-zsh plugin
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ];then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "update zsh theme to powerlevel10k"
    sed -i 's#^ZSH_THEME=.*$#ZSH_THEME="powerlevel10k/powerlevel10k#g' .zshrc
fi
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ];then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ];then
    git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
fi
echo "Please add \`zsh-autosuggestions zsh-syntax-highlighting\` into ~/.zshrc plugins"


# install Ack
if [ ! -x "$(command -v ack)" ];then
    if [ `uname`x = 'Darwin'x ];then
        installCmd ack
    else
        installCmd ack-grep
    fi
fi
