#!/usr/bin/env bash



#[使用设置]

#主目录，相当于/usr/local
#install_dir=

#日志主目录，相当于/var/log
#log_dir=

#服务目录名
redis_dir=redis



get_redis() {
    test_package redis-3.2.9.tar.gz http://shell-auto-install.oss-cn-zhangjiakou.aliyuncs.com/package/redis-3.2.9.tar.gz  0969f42d1675a44d137f0a2e05f9ebd2
}

install_redis() {
    test_dir_master
    test_dir $redis_dir
    package=`get_redis`

    tar -xf package/$package
    mv redis ${install_dir}/${redis_dir}

    grep -w 'PATH=$PATH':${install_dir}/${redis_dir}/bin /etc/profile &> /dev/null
    [ $? -ne 0 ] && echo 'PATH=$PATH':${install_dir}/${redis_dir}/bin >> /etc/profile
    
    echo "redis" >> conf/installed.txt
    
    clear
    if [ $language -eq 1 ];then
        echo "redis 安装成功，请安装redis-port来启动一个实例
        
安装目录：${install_dir}/${redis_dir}

环境变量设置完毕，请退出当前终端后重新进入"
    else
        echo "redis installed successfully, please install redis-port to start an instance
        
installation manual：${install_dir}/${redis_dir}

Environment variable is set, please exit the current terminal and re-enter"
    fi
}

remove_redis() {
    hang=`grep -n 'PATH=$PATH':${install_dir}/${redis_dir}/bin /etc/profile &> /dev/null`
    sed -i "${hang} d" /etc/profile

    for i in `ls /usr/local/bin/man-redis*`
    do
        $i stop
        rm -rf $i
    done
    
    rm -rf ${install_dir}/${redis_dir}

    [ $language -eq 1 ] && echo "redis卸载完成" || echo "redis uninstall completed"
}

info_redis() {
    if [ $language -eq 1 ];then
        echo "名字：redis

版本：3.2.9

作者：book

介绍：仅安装redis，但并不启动实例

提示：可以修改安装路径

使用：安装redis-port 来创建一个实例"
    else
        echo "Name：redis
        
version：3.2.9

Author：book

Introduction：Only redis is installed, but it does not start the instance

Prompt：You can modify the installation path

use：Install redis-port to create an instance"
    fi
}
