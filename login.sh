#!/bin/bash
# 死循环,如果丢包率100就使用curl发请求进行登录
while true
do
	for passwd in $(cat /opt/autoLoginWifi/passwd.conf)
	do
		logNameDate=$(date '+%Y%m%d')
		# result为对baidu的丢包率
		result=$(ping -w 4 -c 4 www.baidu.com | grep packet | awk -F" " '{print $6}'| awk -F"%" '{print $1}')
		echo "$(date) 对www.baidu.com丢包率  ${result}%" >> /opt/autoLoginWifi/log/login-${logNameDate}.log
		if [ ${result} -eq 100 ];then
			echo $(date) 使用账号${passwd%,*}密码${passwd#*,}登录网络 >> /opt/autoLoginWifi/log/login-${logNameDate}.log
			echo "$(date) 执行命令: curl --connect-timeout 30 -m 60 http://lan.wayos.com:88/auth.asp?usr=${passwd%,*}&pwd=${passwd#*,}" >> /opt/autoLoginWifi/log/login-${logNameDate}.log
			echo $(date) 使用账号${passwd%,*}密码${passwd#*,}登录网络
			curl --connect-timeout 30 -m 60 http://lan.wayos.com:88/auth.asp?usr=${passwd%,*}\&pwd=${passwd#*,} >> /opt/autoLoginWifi/log/login-${logNameDate}.log
			echo "" >> /opt/autoLoginWifi/log/login-${logNameDate}.log
		fi
		sleep 1m
	done
done
