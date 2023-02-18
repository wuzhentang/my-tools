#!/bin/bash 

aliyunSource=https://mirrors.aliyun.com/homebrew
ustcSource=https://mirrors.ustc.edu.cn
tencentSource=https://mirrors.cloud.tencent.com/homebrew
tsinghuaSource=https://mirrors.tuna.tsinghua.edu.cn/git/homebrew
githubSource=https://github.com/Homebrew


brewPath=brew.git
homeBrewCorePath=homebrew-core.git
homeBrewCaskPath=homebrew-cask.git
homeBrewBootlesPath=homebrew-bottles

brewConfigPath=~/.brew.source

updateBrewSource() {
    # select brew source
    if [ "$1"x = "aliyun"x ] || [ "$1"x = ""x ];then
        customSource=$aliyunSource
    elif [ "$1"x = "ustc"x ];then
        customSource=$ustcSource
    elif [ "$1"x = "tencent"x ];then
        customSource=$tencentSource
    elif [ "$1"x = "tsinghua"x ];then
        customSource=$tsinghuaSource
    elif [ "$1"x = "github"x ];then
        customSource=$githubSource
    else
        printErrorMsg "source must be one of:aliyun, ustc, tencent, tsinghua"
        return 1;
    fi


    customSource=$aliyunSource
    brewRepo=$customSource/$brewPath
    homebrewCoreRepo=$customSource/$homeBrewCorePath
    homeCaskRepo=$customSource/$homeBrewCaskPath

    # update repos

	# 替换 Homebrew 本身
	git -C "$(brew --repo)" remote set-url origin $brewRepo

	# 替换 Homebrew Core
	# 核心源（仓库），它是 brew install 的默认安装源（仓库）。
	git -C "$(brew --repo homebrew/core)" remote set-url origin $homebrewCoreRepo
    git -C "$(brew --repo homebrew/core)" fetch --unshallow 

	# 替换 Homebrew Cask
    # 提供 macOS 应用和大型二进制文件的安装。通常我们在 mac 操作系统上安装图形用户界面软件，系统都会提示“若要安装，请拖动此图标…”。
    #   homebrew-cask 扩展了Homebrew，为安装和管理 Atom 和 Google Chrome 之类的图形用户界面应用程序带来了优雅、简单和速度。
	git -C "$(brew --repo homebrew/cask)" remote set-url origin $homeCaskRepo
	git -C "$(brew --repo homebrew/cask)" fetch --unshallow 

    
    # store the config
    echo -ne "$customSource" > $brewConfigPath

    # use new config
    brew update
    
	# print config
    printInfoMsg "Now brew config is as follow:"
	brew config
}

# 替换homebrew-bottles
# Homebrew 预编译二进制软件包。
if [ -f $brewConfigPath ] && [ -n `cat $brewConfigPath` ];then
    export HOMEBREW_BOTTLE_DOMAIN=`cat $brewConfigPath`/$homeBrewBootlesPath
else
    printWarnMsg "can't find $brewConfigPath use $aliyunSource instead!"
    export HOMEBREW_BOTTLE_DOMAIN=$aliyunSource/$homeBrewBootlesPath
fi

