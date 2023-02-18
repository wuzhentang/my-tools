
#set -x
set -e

# docker-ce: docker引擎社区版, 负责所有管理工作部分
# docker-ce-cli: docker社区版守护进程的CLI
# containerd: 容器运行时, 与OS API接口的守护进程


# 安装依赖工具
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# 安装GPG证书
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 添加阿里云镜像仓库
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

# 卸载旧版本
sudo apt remove docker docker-engine docker.io containerd runc
# 安装docker
sudo apt install -y docker-ce docker-ce-cli containerd.io

# 将当前用户加入docker组
sudo usermod -aG docker ${USER}
# log in new docker group
newgrp docker
# check user is add to docker group
getent group docker

# 配置开机启动
systemctl enable docker
systemctl start docker

