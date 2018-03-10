#!/usr/bin/env bash
# 暂时无法使用
ssh -i /var/jenkins_home/.ssh/id_rsa -t -t root@172.17.0.1
cd /www/limx/phalcon
git pull && \
composer update --no-dev --prefer-dist -o && \
service server.service restart