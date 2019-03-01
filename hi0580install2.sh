#!/bin/bash
# hi05802 setup on debian
if [ `whoami` = "root" ];then
	echo "Start"
else
	echo "Please switch to 'root'"
	exit
fi
echo -e "----------------set souboat mai0580--------------------------\n"
wget -O /etc/nginx/conf.d/wmai0580.conf https://raw.githubusercontent.com/gitlun/test/master/wmai0580.conf
wget -O /etc/nginx/conf.d/souboat.conf https://raw.githubusercontent.com/gitlun/test/master/souboat.conf
wget -O /etc/nginx/conf.d/submain.conf https://raw.githubusercontent.com/gitlun/test/master/submain.conf

wget -O /tmp/httpscerts.zip https://raw.githubusercontent.com/gitlun/test/master/httpscerts.zip
unzip -o -d /dska/www /tmp/httpscerts.zip

echo -e "######done######\n"