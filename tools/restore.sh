#!/bin/bash
termux-setup-storage
sleep 1
directory="/data/data/com.termux"
n=1

if [ ! $1 ]; then
    echo "未指定容器名称"
    echo "请在第一个参数加上容器名称"
fi

if [ ! $2 ]; then
    echo "未指定恢复包"
    echo "请在第二个参数加上恢复包全称"
fi

while [ -d "${directory}/files${n}" ]; do
    ((n++))
done
mkdir ${directory}/files${n}
echo "{\"dir\":\"/data/data/com.termux/files${n}\",\"systemName\":\"$1\"}" > ${directory}/files${n}/xinhao_system.infoJson

cd ~ && \
tar -v -xzvf ./storage/shared/xinhao/data/$2  -C ${directory}/files${n}
echo "恢复目录: ${directory}/files${n}"