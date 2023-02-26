#**************************************************************************
#
# Author : Wu ZhenTang
# Email  : wuzhentang@hotmail.com
# Creation Time : 2023-02-26 19:16:22
# Last Modified : 2023年02月26日 星期日 19时30分14秒
#
# Description:
#
#***************************************************************************

#doc: https://github.com/iovisor/bcc/blob/master/INSTALL.md

installBcc() {
    if [ `lsb_release -is`x = "Ubuntu"x ];then
        installCmd bpfcc-tools linux-headers-$(uname -r)
        echo "bcc is install in /sbin(/usr/sbin) with -bpfcc extension"
    else
        echo "not support yet, please see: https://github.com/iovisor/bcc/blob/master/INSTALL.md"
    fi
}
installBcc
