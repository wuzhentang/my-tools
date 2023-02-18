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

#setup zsh
if [ ! -x "$(command -v zsh)" ];then
    installCmd zsh
    #setup zsh as default shell
    echo "use zsh as default shell"
    chsh -s /bin/zsh
fi

if [ ! -d ~/.oh-my-zsh ];then
    echo "install oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# install Ack
if [ ! -x "$(command -v ack)" ];then
    if [ `uname`x = 'Darwin'x ];then
        installCmd ack
    else
        installCmd ack-grep
    fi
fi
