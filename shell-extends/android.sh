
# adb
alias adbd="adb devices"
alias adbks="adb kill-server"
alias adbs="adb shell"
alias adbl="adb logcat -b all -v threadtime"
alias adbBoot="adb reboot"
alias adbRoot="adb boot"
alias adbPid="adbs ps | grep -i"
alias adblg="adbl | grep -ia "
alias adbw="adb wait-for-device-usb "
alias adbGetBootApp="adb pm query-receivers --components -a android.intent.action.BOOT_COMPLETED"

if [ $OS = Linux ];then
    FLASH_PATH="$MY_BIN/flash-tools"
    RK_FLASH="$FLASH_PATH/upgrade_tool"
    export PATH=$PATH:$FLASH_PATH
fi

adbTopActivity() {
    if [ "$1"x != ""x ];then
        device = " -s $1 "
    fi
    adb $device shell dumpsys activity top
}

adbAppVersion() {
    if [ "$1"x = ""x ];then
        printErrorMsg "please call with package name"
        return 1
    fi
    adb shell dumpsys package | grep -A18 "Package \[$1\]"
}

# fastboot
alias fastbootrk="sudo fastboot  -i 0x2207 "

fastbootFlash() {
    dirPath=""
    device=""
    flashBoot=false
    flashCache=false
    flashRecovery=false
    flashSystem=false
    flashData=false
    flashUbootpak=false
    flashEmmc=false
    flashMdtp=false
    flashSplash=false
    flashPersist=false
    flashVendor=false


    GETOPT_CMD=`getopt -o abcdD:empP:rsSuv -l all,boot,cache,data,device:,emmc,mdtp,persist,path:,recovery,system,splash,ubootpak,vendor -n $0 -- "$@"`
    echo "GETOPT_CMD:$GETOPT_CMD"
    eval set -- "$GETOPT_CMD"
    while true;
    do
        echo "arg: $1"
        case "$1" in
            -a|--all)
                flashBoot=true
                flashCache=true
                flashData=true
                if [ -f "${dirPath}emmc_appsboot.mbn" ];then
                    flashEmmc=true
                fi
                if [ -f "${dirPath}mdtp.img" ];then
                    flashMdtp=true
                fi
                flashRecovery=true
                flashSystem=true
                if [ -f "${dirPath}splash.img" ];then
                    flashSplash=true
                fi
                if [ -f "${dirPath}persist.img" ];then
                    flashPersist=true
                fi
                if [ -f "${dirPath}ubootpak.bin" ];then
                    flashUbootpak=true
                fi
                if [ -f "${dirPath}vendor.img" ];then
                    flashVendor=true
                fi
                shift 1;;
            -b|--boot)
                flashBoot=true
                shift 1;;
            -c|--cache)
                flashCache=true
                shift 1;;
            -d|--data)
                flashData=true
                shift 1;;
            -D|--device)
                dirPath="$2"
                shift 2;;
            -e|--emmc)
                flashEmmc=true
                shift 1;;
            -m|--mdtp)
                flashMdtp=true
                shift 1;;
            -p|--persist)
                flashPersist=true
                shift 1;;
            -P|--path)
                dirPath=$2
                shift 2;;
            -r|--recovery)
                flashRecovery=true
                shift 1;;
            -s|--system)
                flashSystem=true
                shift 1;;
            -S|--splash)
                flashSplash=true
                shift 1;;
            -u|--ubootpak)
                flashUbootpak=true
                shift 1;;
            -v|--vendor)
                flashVendor=true;
                shift 1;;
            --)
                shift;
                break;
        esac;
    done

    if [ "$dirPath"x = ""x ];then
        echo "Not path is given, use ./ as default!"
        dirPath="./"
    fi

    if [ -n "$dirPath" ] && [[ "$dirPath" != */ ]];then
        dirPath="$dirPath/"
    fi

    echo "The image path:$dirPath"
    if [[ "`adb shell getprop ro.product.brand`" =~ idata* ]];then
        adb reboot bootloader
    else
        adb reboot fastboot
    fi

    if [ "$flashBoot"x = "true"x ];then
        echo "Need flash boot img"
        sudo fastboot flash boot "${dirPath}boot.img"
    fi

    if [ "$flashEmmc"x = "true"x ];then
        echo "Need flash emmc_appsboot"
        sudo fastboot flash aboot "${dirPath}emmc_appsboot.mbn"
    fi

    if [ "$flashMdtp"x = "true"x ];then
        echo "Need flash mdtp.img"
        sudo fastboot flash mdtp "${dirPath}mdtp.img"
    fi

    if [ "$flashSplash"x = "true"x ];then
        echo "Need flash splash.img"
        sudo fastboot flash splash "${dirPath}splash.img"
    fi

    if [ "$flashSplash"x = "true"x ];then
        echo "Need flash persist.img"
        sudo fastboot flash persist "${dirPath}persist.img"
    fi

    if [ "$flashCache"x = "true"x ];then
        echo "Need flash cache img"
        sudo fastboot flash cache "${dirPath}cache.img"
    fi

    if [ "$flashRecovery"x = "true"x ];then
        echo "Need flash recovery img"
        sudo fastboot flash recovery "${dirPath}recovery.img"
    fi


    if [ "$flashSystem"x = "true"x ];then
        echo "Need flash system img"
        sudo fastboot flash system "${dirPath}system.img"
    fi

    if [ "$flashData"x = "true"x ];then
        echo "Need flash data img"
        sudo fastboot flash userdata "${dirPath}userdata.img"
    fi

    if [ "$flashUbootpak"x = "true"x ];then
        echo "Need flash ubootpak img"
        sudo fastboot flash ubootpak "${dirPath}ubootpak.bin"
    fi

    if [ "$flashVendor"x = "true"x ];then
        echo "Need flash vendor img"
        sudo fastboot flash vendor "${dirPath}vendor.img"
    fi
    sudo fastboot reboot
}


rkFlashImages() {
	local dirPath="."
	if [ -n "$1" ];then
		dirPath="$1"
	fi

    pushd  "$dirPath"
	sudo $RK_FLASH di -b boot.img
	sudo $RK_FLASH di -k kernel.img
	sudo $RK_FLASH di -s system.img
	sudo $RK_FLASH di -r recovery.img
	sudo $RK_FLASH di -m misc.img
	sudo $RK_FLASH di -re resource.img
	sudo $RK_FLASH di -p parameter.txt
	sudo $RK_FLASH ul MiniLoaderAll.bin
    popd
}

rkUpgradeFireware() {
	local dirPath="."
    local fileName="update.img"
	if [ -d "$1" ];then
        local dirPath=${1%/}
        fileName="$dirPath"/update.img
    elif [ -f "$1" ];then
        fileName="$1"
	fi
    if [ ! -f $fileName ];then
        printErrorMsg "$fileName is not exist!"
        return;
    fi
	sudo $RK_FLASH UF $fileName
}


# help tools
unpackingRecovery() {
    "$MY_BIN"/unpackbootimg -i "$1" -o "$2"
    pushd "$2"
    rename "s/`basename "$1"`/recovery.img/" `basename "$1"`-*
    mkdir ramdisk
    pushd ramdisk
    gunzip -c ../recovery.img-ramdisk.gz | cpio -i
    popd
    popd
}

packingRecovery() {
    pushd "$1"
    mkbootfs . | minigzip > ../recovery.img-ramdisk.gz.new
    "$MY_BIN/mkbootimg" --kernel "$1/recovery.img-zImage" --ramdisk recovery.img-ramdisk.gz.new -o recovery.img.new
    popd
}

if [ "$OS" = "Mac" ]; then
 emulatorLaunch() {
     ~/Library/Android/sdk/emulator/emulator -avd $1 -netdelay none -netspeed full
 }
fi

# setdefault repo config
export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/'
