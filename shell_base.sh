#set -x
set -e

CURRENT_PATH=$(cd "$(dirname "$0}")";pwd -P )""
echo current path: $CURRENT_PATH
MY_BIN=""
OS="Linux"

installCmd() {
    echo "install $@ ..."
    if [ "$(uname)" = "Darwin" ]; then
        brew install $@
    elif [ "$(uname)" = "Linux" ]; then
        sudo apt install -y $@
    fi
}

configEditor() {
    export VISUAL=vim
    export EDITOR="$VISUAL"
}

main() {
    if [ "$(uname)" = "Darwin" ]; then
        OS="Mac"
        #CURRENT_PATH="$(cd "$(dirname "$0")";pwd -P )"
        source "$(cd "$(dirname "$0")";pwd -P )/shell-extends/utils.sh"
        MY_BIN="$CURRENT_PATH/bin/mac"
        # setup brew config
        source "$CURRENT_PATH/configs/brewConfig.sh"
        source "$CURRENT_PATH/shell-extends/shell_mac.sh"
    elif [ "$(uname)" = "Linux" ]; then
        #CURRENT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")";pwd -P )"
        source "$CURRENT_PATH/shell-extends/utils.sh"
        MY_BIN="$CURRENT_PATH/bin/linux"
        source "$CURRENT_PATH/shell-extends/shell_linux.sh"
    else
        echo -e "\033[34m Not support platform to setup shell environment in:$0\033[0m"
        echo ""
        return 1
    fi

    export PATH=$PATH:$MY_BIN
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MY_BIN/lib64
    configEditor

    source "$CURRENT_PATH/shell-extends/vim.sh"
    source "$CURRENT_PATH/shell-extends/git.sh"
    source "$CURRENT_PATH/shell-extends/android.sh"
    source "$CURRENT_PATH/shell-extends/autojump.sh"
    source "$CURRENT_PATH/shell-extends/dev.sh"
    source "$CURRENT_PATH/shell-extends/docker.sh"
    source "$CURRENT_PATH/shell-extends/ssh.sh"
}

#alias showX509Cert="openssl x509  -text  -in "

main
set +e
#set +x
