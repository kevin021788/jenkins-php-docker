#!/usr/bin/env bash
cp -f ./.env.example ./.env
composer update -o
php run
# 初始化Redis
redis-cli flushall
# 初始化Mysql
mysql -u root -e "CREATE DATABASE IF NOT EXISTS phalcon charset=utf8mb4 collate=utf8mb4_unicode_ci;"
cat "mysql.sql" | mysql -u root phalcon

php run server:service --daemonize
./vendor/bin/phpunit
kill `cat storage/pids/service.pid`