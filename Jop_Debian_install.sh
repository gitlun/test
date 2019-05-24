#!/bin/bash
# Jop_debian_install
#ulimit -Hn 1048576 && wget -qO- https://raw.githubusercontent.com/gitlun/Jop_Debian/master/Jop_Debian_install.sh | bash

#check user
if [ `whoami` = "root" ];then
	echo "Start"
else
	echo "Please switch to 'root'"
	exit
fi
#fdisk
mkdir /dskr
mkdir /dskr/tmp
LOG_FILE="/dskr/tmp/debian_init.log"
>"${LOG_FILE}"
exec &> >(tee "$LOG_FILE")
set -x

echo -e "\033[43;30m -------------Setup Swap------------- \033[0m"

swapoff -a
dd if=/dev/zero of=/root/swapfile bs=1M count=512
chmod 0600 /root/swapfile
mkswap /root/swapfile
echo "/root/swapfile swap swap defaults 0 0" >> /etc/fstab
swapon -a

echo -e "\033[42;30m -------------Setup Swap Done------------- \033[0m \n"

echo -e "\033[43;30m -------------Reset to default------------- \033[0m"

mv /etc/ssh/sshd_config /dskr/tmp
mv /etc/sysctl.conf /dskr/tmp
mv /etc/security/limits.conf /dskr/tmp
wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/gitlun/Jop_Debian/master/sshd_config_default
wget -O /etc/sysctl.conf https://raw.githubusercontent.com/gitlun/Jop_Debian/master/sysctl_default.conf
wget -O /etc/security/limits.conf https://raw.githubusercontent.com/gitlun/Jop_Debian/master/limits.conf

echo -e "\033[42;30m -------------Reset to default Done------------- \033[0m \n"

echo -e "\033[43;30m -------------Update Debian------------- \033[0m"
mv /etc/apt/sources.list /dskr/tmp
wget -O /etc/apt/sources.list https://raw.githubusercontent.com/gitlun/Jop_Debian/master/apt.source
apt update
export DEBIAN_FRONTEND=noninteractive
apt -y full-upgrade

echo -e "\033[43;30m -------------Update Debian Done------------- \033[0m \n"

echo -e "\033[43;30m -------------reconfig locales------------- \033[0m"
#sed 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
#locale-gen
#sed 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
echo -e "\033[42;30m -------------reconfig locales done------------- \033[0m \n"

wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/gitlun/Jop_Debian/master/sshd_config_new
service sshd restart
mkdir /dskr/tmp/defaultsysctl
mv /etc/sysctl.conf /dskr/tmp/defaultsysctl
wget -O /etc/sysctl.conf https://raw.githubusercontent.com/gitlun/Jop_Debian/master/sysctl.conf_new
sysctl -p
echo "root soft nofile 65535" >> /etc/security/limits.conf
echo "* soft nofile 65535" >> /etc/security/limits.conf
echo "* hard nofile 65535" >> /etc/security/limits.conf

echo -e "\033[43;30m -------------Install sudo------------- \033[0m"
apt -y install sudo
echo -e "\033[42;30m -------------Install sudo done------------- \033[0m \n"

echo -e "\033[43;30m -------------Install nginx docker------------- \033[0m"

apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common lsb-release
echo "deb http://nginx.org/packages/mainline/debian stretch nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -

curl -fsSL http://mirrors.cloud.aliyuncs.com/docker-ce/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] http://mirrors.cloud.aliyuncs.com/docker-ce/linux/debian $(lsb_release -cs) stable"
apt update
apt -y install nginx
apt -y install docker-ce docker-ce-cli containerd.io

echo -e "\033[42;30m -------------Install nginx docker done------------- \033[0m \n"

echo -e "\033[43;30m -------------Install nvm node------------- \033[0m"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
source /root/.bashrc
nvm install 12
npm install pm2 -g
echo -e "\033[42;30m -------------Install nvm node done------------- \033[0m \n"

echo -e "\033[43;30m -------------Install xfce4------------- \033[0m"
apt -y install xfce4 xfce4-goodies lightdm-gtk-greeter-settings
systemctl set-default multi-user.target
echo -e "\033[42;30m -------------Install xfce4 done------------- \033[0m \n"

echo -e "\033[43;30m -------------Install font------------- \033[0m"
apt -y install fonts-wqy-microhei fonts-wqy-zenhei xfonts-wqy
echo -e "\033[42;30m -------------Install font done------------- \033[0m \n"

echo -e "\033[43;30m -------------Install fcitx------------- \033[0m"
apt -y install fcitx fcitx-sunpinyin
echo -e "\033[42;30m -------------Install fcitx done------------- \033[0m \n"

echo -e "\033[43;30m -------------Install extr------------- \033[0m"
apt -y install firefox-esr default-jre-headless
echo -e "\033[42;30m -------------Install extr done------------- \033[0m \n"

echo -e "\033[43;30m -------------Install netdata------------- \033[0m"
#apt -y install netdata --no-install-recommends
apt -y install tigervnc-standalone-server
echo -e "\033[42;30m -------------Install netdata done------------- \033[0m \n"

echo -e "\033[43;30m -------------Clean------------- \033[0m"
apt -y autoremove
apt -y autoclean
echo -e "\033[42;30m -------------Clean Done------------- \033[0m \n"