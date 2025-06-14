#!/bin/bash
set -e

echo "📦 正在创建配置目录..."
mkdir -p /etc/sub-store

echo "🚀 开始部署 Sub-Store ..."
docker run -it -d --restart=always \
  -e "SUB_STORE_CRON=50 23 *" \
  -e SUB_STORE_FRONTEND_BACKEND_PATH=/T3B9dgzBzdRbBF8Aqx7P \
  -p 3008:3001 \
  -v /etc/sub-store:/opt/app/data \
  --name Sub2Store xream/sub-store:latest

echo "🚀 开始部署 SubConverter ..."
docker run -d --name Sub2Converter --restart=always \
  -p 25500:25500 \
  ghcr.io/metacubex/subconverter:latest

echo "🚀 开始部署 SubWeb ..."
docker run -d --name=SubWeb \
  -p 8091:80 \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=Asia/Shanghai \
  --restart always \
  careywong/subweb:latest

echo -e "\n✅ 所有服务部署完成！你可以访问以下页面：\n"
echo "🔗 Sub-Store： http://192.168.3.1:3008/?api=http://192.168.3.1:3008/T3B9dgzBzdRbBF8Aqx7P"
echo "🔗 SubConverter： http://你的IP:25500"
echo "🔗 SubWeb： http://你的IP:8091"
