#!/bin/bash

CTID=120 GATEWAY="192.168.88.15" TEMPLATE="debian-12-standard_12.7-1_amd64.tar.zst" HOSTNAME="2fauth"

自动选择可用存储池

for POOL in local-lvm local; do if pvesm status | grep -q "^$POOL" && pveam list $POOL | grep -q "$TEMPLATE"; then STORAGE=$POOL break elif pvesm status | grep -q "^$POOL"; then STORAGE=$POOL echo "===> 模板不存在，正在下载至 [$POOL]..." pveam update && pveam download $POOL $TEMPLATE break fi done

if [ -z "$STORAGE" ]; then echo "❌ 未找到支持的存储池（local 或 local-lvm）" exit 1 fi

自动跳过已占用 IP

for i in {100..199}; do ping -c1 -W1 192.168.88.$i &>/dev/null if [ $? -ne 0 ]; then IP="192.168.88.$i/24" break fi done

创建 LXC 容器

echo "===> 创建 2FAuth 容器 [$CTID]，IP=$IP" pct create $CTID ${STORAGE}:vztmpl/$TEMPLATE 
--hostname $HOSTNAME 
--net0 name=eth0,bridge=vmbr0,ip=$IP,gw=$GATEWAY 
--memory 1024 
--cores 2 
--unprivileged 1 
--rootfs $STORAGE:4 
--features nesting=1 
--start 1 || { echo "❌ 容器创建失败！"; exit 1; }

安装2FAuth

pct exec $CTID -- bash -c " apt update && apt install -y curl unzip sudo lsb-release gnupg mariadb-server nginx composer \ php8.3-{bcmath,common,ctype,curl,fileinfo,fpm,gd,intl,mbstring,mysql,xml,cli} && curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/deb.sury.org-php.gpg && echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ \$(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && apt update && apt install -y php8.3-fpm && DB_PASS="$(openssl rand -base64 18 | tr -dc 'a-zA-Z0-9' | head -c13)" && mariadb -u root -e "CREATE DATABASE 2fauth_db; CREATE USER '2fauth'@'localhost' IDENTIFIED BY '$DB_PASS'; GRANT ALL ON 2fauth_db.* TO '2fauth'@'localhost'; FLUSH PRIVILEGES;" && curl -L -o 2fauth.zip https://github.com/Bubka/2FAuth/archive/refs/heads/main.zip && unzip 2fauth.zip && mv 2FAuth-main /opt/2fauth && cd /opt/2fauth && cp .env.example .env && composer install --no-dev --prefer-source --no-plugins --no-scripts && php artisan key:generate --force && php artisan migrate --force && php artisan passport:install -q -n && php artisan storage:link && php artisan config:cache && chown -R www-data:www-data /opt/2fauth && chmod -R 755 /opt/2fauth "

提示

echo "✅ 2FAuth 安装完成，请访问: http://$(echo $IP | cut
