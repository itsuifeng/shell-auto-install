#!/usr/bin/env bash



#[使用设置]

#将安装或卸载如下端口实例
port=(6379)


source script/redis.sh

get_redis_port() {
    get_redis
}

install_redis_port() {
    test_rely redis
    
    for i in `echo ${port[*]}`
    do
        command=/usr/local/bin/man-redis${i} #创建一个管理脚本
        if [ ! -f $command ];then
            cp conf/redis/man-redis $command
        
            sed -i "2a port=${i}" $command
            sed -i "3a install_dir=${install_dir}" $command
            sed -i "4a log_dir=${log_dir}" $command
            sed -i "5a redis_dir=${redis_dir}" $command
        
            chmod +x $command
        else
            continue #如果管理脚本存在，则不创建了
        fi

        conf=${install_dir}/${redis_dir}/cluster/${i}/${i}.conf
    
        mkdir -p ${install_dir}/${redis_dir}/cluster/${i}
        cp conf/redis/7000.conf $conf
    
        sed -i "/^port/cport ${i}" $conf
        sed -i "/^cluster-config-file/ccluster-config-file nodes_${i}.conf" $conf
        sed -i "/^pidfile/cpidfile redis_${i}.pid" $conf
        sed -i "/^dir/cdir ${install_dir}/${redis_dir}/cluster/${i}" $conf 
    done

    echo "#!/bin/bash

for i in `ls man-redis*`
do  
    [ "$i" == "man-redis" ] && continue || $i $1
done" >> /usr/local/bin/man-redis
    chmod + /usr/local/bin/man-redis

    clear
    [ $language -eq 1 ] && echo "使用man-redis命令来管理这些端口实例" || echo "Use the man-rediscommand to manage these port instances"
}

remove_redis_port() {
    for i in `echo ${port[*]}`
    do
        /usr/local/bin/redis${i} stop
        rm -rf /usr/local/bin/redis${i}
        rm -rf ${install_dir}/${redis_dir}/cluster/${i}
    done

    [ $language -eq 1 ] && echo "redis ${port[*]} 端口卸载完成" || "redis ${port[*]} Port uninstallation is complete" 
}

info_redis_port() {
    if [ $language -eq 1 ];then
        echo "名字：redis-port
        
版本：3.2.9

作者：book

介绍：仅启动实例端口，需要先安装redis

提示：不管安装或卸载端口，都会安装配置文件写的来

使用：man-redis来查看帮助"
    else
        echo "Name：redis-port
       
version：3.2.9

Author：book

Introduction：Only start the instance port, you need to install redis

Prompt：Whether to install or uninstall the port, will be installed to write the configuration file

use：man-redis to see help"
    fi
}
