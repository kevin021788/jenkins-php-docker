#!/usr/bin/env bash
version='8.10.0'
wget https://nodejs.org/dist/v${version}/node-v${version}-linux-x64.tar.gz
tar xzf node-v${version}-linux-x64.tar.gz

mkdir -p /home/jenkins/nodejs/${version}
cp -rf node-v${version}-linux-x64/* /home/jenkins/nodejs/${version}

ln -sf /home/jenkins/nodejs/${version}/bin/node /home/jenkins/bin/node
ln -sf /home/jenkins/nodejs/${version}/bin/npm /home/jenkins/bin/npm

echo checking nodejs:
/home/jenkins/bin/node -v

echo checking npm:
/home/jenkins/bin/npm -v

# 设置镜像源
/home/jenkins/bin/npm config set registry=http://registry.npm.taobao.org

# 删除下载文件夹
rm -rf node-v${version}-linux-x64