#!/bin/bash
# hi0580 setup on debian
LOG_FILE="/tmp/hi0580.log"
>"${LOG_FILE}"
exec &> >(tee "$LOG_FILE")
set -x
echo -e "----------------SETBASE--------------------------\n"

echo "######Update Debian######"
wget -O /tmp/apt.source https://raw.githubusercontent.com/gitlun/test/master/apt.source
cp -f /tmp/apt.source /etc/apt/sources.list
apt update
export DEBIAN_FRONTEND=noninteractive
apt -y full-upgrade
echo -e "######done######\n"

echo "######reconfig locales######"
#sed 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
#locale-gen
#sed 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
echo -e "######done######\n"

echo -e "----------------SETPROJECT--------------------------\n"
echo "######Install sudo######"
apt -y install sudo
echo -e "######done######\n"

echo "######Install xfce4######"
apt -y install xfce4 xfce4-goodies lightdm-gtk-greeter-settings
systemctl set-default multi-user.target
echo -e "######done######\n"

echo "######Install font######"
apt -y install fonts-wqy-microhei fonts-wqy-zenhei xfonts-wqy
echo -e "######done######\n"

echo "######Install fcitx######"
apt -y install fcitx fcitx-sunpinyin
echo -e "######done######\n"

echo "######Install extr######"
apt -y install firefox-esr openjdk-8-jre-headless
echo -e "######done######\n"

echo "######Install netdata######"
apt -y install netdata --no-install-recommends
echo -e "######done######\n"

echo "######Install docker######"
apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt -y install docker-ce docker-ce-cli containerd.io

echo -e "----------------CLEAN--------------------------\n"
echo "######Clean######"
apt -y autoremove
apt autoclean
echo -e "######done######\n"


#echo -e "----------------INSTALL EXTR--------------------------\n"
#echo "######Dbeaver######"
#wget -O /tmp/dbeaver.tar.a http://m.mai0580.com/client/theme/sg/cn/mob/extr/dbeaver.tar.a
#wget -O /tmp/dbeaver.tar.b http://m.mai0580.com/client/theme/sg/cn/mob/extr/dbeaver.tar.b
#wget -O /tmp/dbeaver.tar.c http://m.mai0580.com/client/theme/sg/cn/mob/extr/dbeaver.tar.c
#cd /tmp
#cat dbeaver.tar.* | tar xzvf - 
#dpkg -i ./dbeaver-ce_5.3.5_amd64.deb
#cd
#echo -e "######done######\n"

#scp apt.source lun@192.168.1.126:/tmp
