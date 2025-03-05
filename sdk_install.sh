#!/bin/bash
set -euo pipefail

# 安装SDKMAN!（如果尚未安装）
if [ ! -d "$HOME/.sdkman" ]; then
    echo "正在安装SDKMAN!..."
    curl -s "https://get.sdkman.io" | bash
else
    echo "SDKMAN! 已安装，跳过安装步骤"
fi

# 加载SDKMAN!环境变量
source "$HOME/.sdkman/bin/sdkman-init.sh"

# 验证安装
echo "SDKMAN! 版本信息："
sdk version

# 安装Kona JDK版本（自动确认）
echo "正在安装 Java 17.0.13-kona..."
sdk install java 17.0.13-kona -y

echo "正在安装 Java 8.0.432-kona..."
sdk install java 8.0.432-kona -y

echo "所有Java版本安装完成！"

# 可选：列出已安装的Java版本
echo -e "\n当前已安装的Java版本："
sdk list java | grep -E '(installed)|(========)'
