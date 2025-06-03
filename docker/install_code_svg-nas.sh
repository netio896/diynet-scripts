#!/bin/bash

# 创建目录
mkdir -p /volume1/docker/code-svg && cd /volume1/docker/code-svg

# 写入 docker-compose.yml 文件
cat <<EOF > docker-compose.yml
version: '3'
services:
  code-server:
    image: docker.diynet.club/linuxserver/code-server:latest
    container_name: code-svg
    environment:
      - PUID=0
      - PGID=0
      - TZ=Asia/Yangon
      - PASSWORD=sanda1985  # 可改密码
    volumes:
      - /volume1/docker/code-svg/data:/config
    ports:
      - "8890:8443"
    restart: unless-stopped
EOF

# 启动服务
docker-compose up -d

echo "✅ code-server 已部署完成，浏览器访问：https://<你的IP>:8890"
echo "🔐 登录密码为：sanda1985（可在 docker-compose.yml 中修改）"
