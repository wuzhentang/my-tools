


setupKeyboardMap() {
    local myInputrcPath="$CURRENT_PATH/configs/inputrc"
    if ! grep -q $myInputrcPath ~/.inputrc; then
        echo "\$include $myInputrcPath" >> ~/.inputrc
    fi
}

addSiteCertToConfig() {
	hostname="$1"
	port=443
	trust_cert_file_location=`curl-config --ca`

	sudo bash -c "echo -n | openssl s_client -showcerts -connect $hostname:$port -servername $hostname \
        2>/dev/null  | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'  \
            >> $trust_cert_file_location"
}

getKenerlConfig() {
    if [ -f /proc/config.gz ];then
		zcat /proc/config.gz
	elif [ -f /boot/config ];then
		cat /boot/config
	elif [ -f /boot/config-$(uname -r) ];then
		cat /boot/config-$(uname -r)
	else
		printErrorMsg "kernel config file not found"
	fi
}

setupKeyboardMap
