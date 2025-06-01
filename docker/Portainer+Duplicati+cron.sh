mkdir -p /volume1/docker/portainer /volume1/docker/duplicati /volume1/docker/backup

# 创建 docker-compose.yml
cat <<EOF > /volume1/docker/docker-tools/docker-compose.yml
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
    image: lscr.io/linuxserver/duplicati
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

cd /volume1/docker/docker-tools
docker-compose up -d
