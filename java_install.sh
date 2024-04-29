#!/bin/bash

sudo yum update

java_version_Arr=("java-1.8.0-openjdk-devel" "java-17-openjdk-devel")

choice_version(){
    echo "请选择安装选项："
    for index in "${!java_version_Arr[@]}"; do
        echo "${index}、${java_version_Arr[$index]}"
    done
    # 根据用户选择执行相应的操作
    read -p "请输入选项：" choice

    # 判断choice是否为非数字
    if ! [[ $choice =~ ^[0-9]+$ ]]; then
        echo "无效选择"
        exit 1
    fi

    # 判断choice是否大于数组下标
    if (( choice >= ${#java_version_Arr[@]} )); then
        echo "无效选择"
        exit 1
    fi
    echo "开始安装 ${java_version_Arr[$choice]}"
    install_jdk "${java_version_Arr[$choice]}"
}

install_jdk(){
    local jdk_version=$1
    #1、判断是否已安装
    rpm -q "$jdk_version" > /dev/null 2>&1
    # 检查命令执行的返回值（0表示安装了，1表示未安装）
    if [ $? -eq 0 ]; then
        echo "$jdk_version 已安装。"
    else
        echo "$jdk_version 未安装。准备安装..."
    fi

    #2、查找可用的jdk版本
    # 执行yum命令并将输出保存到临时文件
    yum_list_output=$(yum list available $jdk_version 2>/dev/null)
    # 检查输出是否为空
    if [[ $yum_list_output == *"无匹配的软件包可供显示"* || $yum_list_output == *"No matching Packages to list"* ]]; then
        echo "没有找到可用的 $jdk_version 版本"
    else
        echo "以下是可用的 $jdk_version 版本："
        echo "$yum_list_output"

        # 开始安装
        yum install -y "$jdk_version"
    fi
}
choice_version



