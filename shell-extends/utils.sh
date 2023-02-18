
printErrorMsg(){
    # red
    echo -e "\033[31m ERROR:$@ \033[0m"
}

printWarnMsg(){
    # yellow
    echo -e "\033[33m WARN:$@ \033[0m"
}

printInfoMsg() {
    # green
    echo -e "\033[32m INFO:$@ \033[0m"
}

printDebugMsg() {
    # blue
    echo -e "\033[34m DEBUG:$@ \033[0m"
}


connVpn() {
    local cfgPath=~/.vpn/myVpn.ovpn
    local passPath=~/.vpn/pass.txt
    if [ ! -f $cfgPath ];then
        printErrorMsg "$cfgPath not found"
	return
    fi
    if [ ! -f $passPath ];then
        printErrorMsg "$passPath not found"
	return
    fi
    sudo openvpn --config $cfgPath --auth-user-pass $passPath --daemon
}
