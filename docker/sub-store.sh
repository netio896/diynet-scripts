# 创建所需目录
mkdir -p /volume1/docker/sub-store-data

# 写入 docker-compose.yml
cat <<'EOF' > /volume1/docker/sub-store-data/docker-compose.yml
version: "3.8"

services:
  sub-store:
    image: xream/sub-store:latest
    container_name: sub-store
    network_mode: host
    restart: always
    volumes:
      - /volume1/docker/sub-store-data:/opt/app/data
    environment:
      - SUB_STORE_BACKEND_CRON=0 0 * * *
      - SUB_STORE_FRONTEND_BACKEND_PATH=/1234567890
      - SUB_STORE_FRONTEND_HOST=0.0.0.0
      - SUB_STORE_FRONTEND_PORT=3001
      - SUB_STORE_DATABASE_PATH=/opt/app/data
      - SUB_STORE_BACKEND_API_HOST=0.0.0.0
      - SUB_STORE_BACKEND_API_PORT=3002
    stdin_open: true
    tty: true
EOF
