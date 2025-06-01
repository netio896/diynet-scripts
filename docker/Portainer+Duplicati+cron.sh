#!/bin/bash
# 自动部署 Portainer + Duplicati，适用于群晖、Ubuntu、PVE
# 作者：Sanda 专用版

# 设置工作目录
WORKDIR="/volume1/docker/docker-tools"
mkdir -p "$WORKDIR"

# 写入 docker-compose.yml
cat <<EOF > "$WORKDIR/docker-compose.yml"
version: '3'

services:
  portainer:
    image: portainer/portainer-ce
    container_name: portainer
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /volume1/docker/portainer:/data
    restart: always

  duplicati:
    image: docker.diynet.club/linuxserver/duplicati
    container_name: duplicati
    ports:
      - "8200:8200"
    environment:
      - PUID=0
      - PGID=0
      - TZ=Asia/Yangon
    volumes:
      - /volume1/docker:/source
      - /volume1/docker/backup:/backups
      - /volume1/docker/duplicati:/config
    restart: always
EOF

# 启动容器服务
cd "$WORKDIR"
docker compose up -d

# 输出访问地址提示
echo ""
echo "✅ 部署完成！你现在可以访问以下服务："
echo "Portainer 面板： http://NAS-IP:9000"
echo "Duplicati 备份： http://NAS-IP:8200"
