#!/bin/bash

installGo() {
    if [ $OS = Linux ];then
        if [ $1 = "apt" ];then
            sudo apt install -y golang-go
        else
        	rm -rf /tmp/go
        	pushd /tmp/go
        	wget https://go.dev/dl/go1.20.linux-amd64.tar.gz
        	tar -xvf go1.20.linux-amd64.tar.gz
        	sudo mv go /usr/local
        	popd
        	rm -rf /tmp/go
        	echo 'Please add following variable \
                export GOROOT=/usr/local/go \
                export GOPATH=$HOME/go \
                export PATH=$GOPATH/bin:$GOROOT/bin:$PATH'
        fi
    else
        printError "Not supprt install go"
    fi
}
installGo apt


