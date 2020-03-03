#!/bin/bash
# ping百度拿到丢包率,丢包率100则返回1其余返回0
pingBaidu(){
	result=$(ping -w 4 -c 4 www.baidu.com | grep packet | awk -F" " '{print $6}'| awk -F"%" '{print $1}')
	return ${result}
}
# 死循环,如果丢包率100就使用curl发请求进行登录
while true
do
	for passwd in $(cat passwd.txt)
	do
	  sleep 1m
		pingBaidu
		p=$?
		logNameDate=$(date '+%Y%m%d')
		echo "$(date) 对www.baidu.com丢包率  ${p}%" >> /opt/autoLoginWifi/log/login-${logNameDate}.log
		if [ ${p} -eq 100 ];then
			echo $(date) 使用账号${passwd%,*}密码${passwd#*,}登录网络 >> /opt/autoLoginWifi/log/login-${logNameDate}.log
			echo "$(date) 执行命令: curl --connect-timeout 5 -m 10 http://lan.wayos.com:88/auth.asp?usr=${passwd%,*}&pwd=${passwd#*,}" >> /opt/autoLoginWifi/log/login-${logNameDate}.log
			echo $(date) 使用账号${passwd%,*}密码${passwd#*,}登录网络
			curl --connect-timeout 30 -m 60 http://lan.wayos.com:88/auth.asp?usr=${passwd%,*}\&pwd=${passwd#*,} >> /opt/autoLoginWifi/log/login-${logNameDate}.log
		fi
	done
done
