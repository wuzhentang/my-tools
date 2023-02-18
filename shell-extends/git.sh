
# config git
if [ ! -f ~/.gitconfig ];then
    cp "$CURRENT_PATH/configs/gitconfig"  ~/.gitconfig
fi
if [ "`git config --global --get core.editor`"x != "vim"x ];then
    git config --global core.editor vim
fi

if [ "$OS" = "Mac" ]; then
    # fix git status garbled character
    if [ "`git config --get --global core.quotepath`"x != "false"x ];then
        git config --global core.quotepath false
    fi
fi

# git helper
gitStat4Each() {
    git log --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done
}

gitStatByAuthor() {
    if [ -e "$1" ];then
        printErrorMsg "muse call with author name"
        return -1
    fi
    git log --author="$1" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
}

gitContributors() {
    git log --pretty='%aN' | sort -u
}

gitTop5Contributors() {
    git log --pretty='%aN' | sort | uniq -c | sort -k1 -n -r | head -n 5
}

