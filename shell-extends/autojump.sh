
# install autoJump
if [ ! -x "$(command -v autojump)" ];then
     installCmd autojump
fi

#setup autojump
if [ "$OS" = "Mac" ]; then
    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
elif [ "$(uname)" = "Linux" ]; then
    . /usr/share/autojump/autojump.sh
fi
