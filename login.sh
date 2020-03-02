#!/bin/bash
logNameDate=$(date '+%Y%m%d')
# ping百度拿到丢包率,丢包率100则返回1其余返回0
pingBaidu(){
	result=$(ping -w 4 -c 4 www.baidu.com | grep packet | awk -F" " '{print $6}'| awk -F"%" '{print $1}')
	echo "$(date) 丢包率 ${result}%"
	if [ ${result} -eq 100 ];then
		return 1
	else
		return 0
	fi
}
# 死循环,如果丢包率100就使用curl发请求进行登录
while true
do
	for passwd in $(cat passwd.conf)
	do
	#	sleep 1m
		pingBaidu
		echo "$(date) 对www.baidu.com是否丢包(1为丢包,0为没有)  $?" >> log/login-${logNameDate}.log
		if [ $? -eq 0 ];then
			echo $(date) 使用账号${passwd%,*}密码${passwd#*,}登录网络
			echo "$(date) 执行命令: curl --connect-timeout 5 -m 10 http://lan.wayos.com:88/auth.asp?usr=${passwd%,*}&pwd=${passwd#*,}"
			echo $(date) 使用账号${passwd%,*}密码${passwd#*,}登录网络 >> log/login-${logNameDate}.log
			curl --connect-timeout 30 -m 60 http://lan.wayos.com:88/auth.asp?usr=${passwd%,*}\&pwd=${passwd#*,} >> log/login-${logNameDate}.log
			echo "" >> log/login-${logNameDate}.log
		fi
	done
done
