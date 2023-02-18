


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

setupKeyboardMap
