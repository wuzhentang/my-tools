#!/bin/bash

formatDiskExt4() {
    local diskPath=""

    while true;
    do
        sudo fdisk -l
        read -p "Which disk do you want to formate? Plase input path:" diskPath
        if [ -e $diskPath ];then
            read -p "CONFIRM: do you want to format(y/n):$diskPath" a
            if [ $a = "y" ] || [ $a = "Y" ] || [ $a = "yes" ];then
                break;
            else
                printWarnMsg "Wrong answer:$a"
            fi
        fi
    done

	sudo mkfs.ex4 $diskPath
	read -p "Is need mount to auto mount (y/n)?" a
	if [ $a != "y" ] && [ $a != "Y" ] && [ $a != "yes"  ];then
		printInfoMsg "Not auto mount $diskPath"
		return
	fi

	read -p "Please input mount path:" mountPath
	if [ ! -e $mountPath ];then
		read -p "$mountPath is not exist! Do you want to create it?(y/n)" a
		if [ $a = y ] || [ $a = Y ] || [ $a = "yes"  ];then
			mkdir -p "$mountPath"
		else
			printErrorMsg "Abort auto mount for mount point is not exists!"
			return 1
		fi
	fi

	if [ ! -d $mountPath ];then
		printErrorMsg "$mountPath is not a valid directory, abort auto mount!"
		return 1
	fi
    local diskIdInfo=`sudo blkid  $diskPath | awk '{print $2}'`
	sudo echo "$diskIdInfo    $mountPath    ext4    defaults     0     0" >> fstab
	printInfoMsg "Format $diskPath for ext4 and auto mount on $mountPath success"
}
formatDiskExt4
