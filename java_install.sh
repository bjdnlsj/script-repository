#!/bin/bash

sudo yum update 

install_jdk(){
    local jdk_version=$1
    # 执行yum命令并将输出保存到临时文件
    yum_list_output=$(yum list available '${jdk_version}' 2>/dev/null)
    # 检查输出是否为空
    if [ -z "$yum_list_output" ]; then
        echo "没有找到可用的 $jdk_version 版本"
    else
        echo "以下是可用的 $jdk_version 版本："
        echo "$yum_list_output"
    fi
}

echo "请选择安装选项："
echo "1. java-1.8.0"
echo "2. java-17"

read choice

# 定义菜单选项
options=("选项一" "选项二" "退出")

# 根据用户选择执行相应的操作
case $choice in
  1)
    echo "开始安装 java-1.8.0"
    # 在这里编写执行选项一的代码 
    install_jdk "java-1.8.0-openjdk-devel"
    ;;
  2)
    echo "开始安装 java-17"
    # 在这里编写执行选项二的代码
    install_jdk "java-17-openjdk-devel"
    ;;
  *)
    echo "无效的选择"
    ;;
esac




