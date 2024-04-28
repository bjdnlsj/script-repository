#!/bin/bash
eletile_mirror='\
      <mirror>\
          <id>eletile-group</id>\
          <mirrorOf>*</mirrorOf>\
          <url>http://10.1.7.101:8081/repository/eletile-group/</url>\
      </mirror>'

eletile_servers='\
     <server>\
          <id>eletile-releases</id>\
          <username>sjm</username>\
          <password>sjm</password>\
      </server>\
      <server>\
         <id>eletile-snapshots</id>\
         <username>sjm</username>\
         <password>sjm</password>\
      </server>\
      <server>\
        <id>eletile-group</id>\
        <username>sjm</username>\
        <password>sjm</password>\
    </server>'

eletile_repository_dir='\
        <localRepository>/home/repository</localRepository>'

install_maven(){
  local mvn_version=$1
  local dir=$2
  local url="https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-${mvn_version}-bin.tar.gz"

  echo "即将下载的地址：$url"
  echo "即将安装的目录：$dir"

  # 创建目录并进入
  mkdir -p /opt/maven && cd /opt/maven

  # 拼接文件路径
  file_path="/opt/maven/apache-maven-${mvn_version}"

  # wget 不存在则安装 wget
  if [ -z "$(command -v wget)" ]; then
      yum -y install wget
      if [ $? -eq 0 ]; then
        echo "wget安装完成"
      else
        echo "wget安装失败，请检查"
        exit 1
      fi
  fi

  # 判断目录是否存在
  if [ ! -d "$file_path" ]; then

     # 下载文件、解压、删除压缩包
     sudo wget ${url}
     sudo tar xzf apache-maven-${mvn_version}-bin.tar.gz
     rm -rf apache-maven-${mvn_version}-bin.tar.gz
  else
     # else输出目录已存在
     echo "目录已存在，无需下载"
  fi
  echo "安装完成!"
  echo "开始设置环境变量……"
  if [ -z "$MAVEN_HOME" ]; then
      # 设置环境变量
      echo >> /etc/profile
      echo '#MAVEN_HOME' >> /etc/profile
      echo "export MAVEN_HOME=${file_path}" >> /etc/profile
      echo 'export PATH=$PATH:$MAVEN_HOME/bin' >> /etc/profile
  else
    echo "MAVEN_HOME已有设置：$MAVEN_HOME"
  fi
  # 开始设置镜像
  sed -i '/<\/mirrors>/i '"$eletile_mirror"'' "${file_path}/conf/settings.xml"
  if [ $? -eq 0 ]; then
    echo "eletile镜像站,mirrors设置成功"
  else
    echo "eletile镜像站,mirrors设置失败，请查看异常信息后重试"
    exit 1
  fi

  sed -i '/<\/servers>/i '"$eletile_servers"'' "${file_path}/conf/settings.xml"
  if [ $? -eq 0 ]; then
      echo "eletile镜像站,servers设置成功"
    else
      echo "eletile镜像站,servers设置失败，请查看异常信息后重试"
      exit 1
  fi

  sed -i '/<\/settings>/i '"$eletile_repository_dir"'' "${file_path}/conf/settings.xml"
  if [ $? -eq 0 ]; then
      echo "eletile镜像站,repository设置成功"
    else
      echo "eletile镜像站,repository设置失败，请查看异常信息后重试"
      exit 1
  fi



  source /etc/profile
  echo "maven下载、安装、配置完成"
}
install_maven "3.9.6" "/opt/maven"

exit 0
