mkdir -p ~/sub-tools && cd ~/sub-tools

cat <<EOF > docker-compose.yml
version: '3.8'

services:
  substore:
    image: xream/sub-store:latest
    container_name: Sub2Store
    restart: always
    ports:
      - "3008:3001"
    environment:
      - SUB_STORE_CRON=50 23 *
      - SUB_STORE_FRONTEND_BACKEND_PATH=/T3B9dgzBzdRbBF8Aqx7P
    volumes:
      - /etc/sub-store:/opt/app/data

  subconverter:
    image: metacubex/subconverter:latest
    container_name: Sub2Converter
    restart: always
    ports:
      - "25500:25500"

  subweb:
    image: careywong/subweb:latest
    container_name: SubWeb
    restart: always
    ports:
      - "8091:80"
    environment:
      - PUID=0
      - PGID=0
      - TZ=Asia/Yangon
EOF

docker compose up -d
