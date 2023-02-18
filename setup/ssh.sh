

installSshServer() {
    if [ $OS = Linux ];then
        installCmd openssh-server

        #配置/etc/ssh/sshd_config
        read -p "Please open new terminal to config sshd in /etc/ssh/sshd_config, then input a char to continue" _

        #开机启动
        sudo systemctl enable ssh
        # 打开防火墙
        sudo ufw allow 5200
        sudo ufw status

        #关闭自启动
        #sudo systemctl disable ssh

        #查看状态
        sudo systemctl status ssh
    fi
}
installSshServer
