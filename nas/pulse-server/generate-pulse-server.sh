cat <<'EOF' > nas/pulse-server/generate-pulse-server.sh
#!/bin/bash
mkdir -p /volume1/docker/pulse
cd /volume1/docker/pulse || exit 1

echo "✅ 正在创建 .env 文件..."
cat <<EOT > .env
# 默认连接的 PVE 节点（你可以在程序中动态选择）
PROXMOX_HOST=https://192.168.88.33:8006
PROXMOX_TOKEN_ID=root@pam!pulse
PROXMOX_TOKEN_SECRET=请手动填写你的真实Token

# 如需备用节点，可加在程序逻辑中选择使用
# PROXMOX_HOST=https://192.168.88.35:8006
# PROXMOX_TOKEN_ID=root@pam!pulse
# PROXMOX_TOKEN_SECRET=请手动填写你的备用Token
EOT

echo "✅ 正在创建 Dockerfile..."
cat <<EOT > Dockerfile
FROM node:18-alpine

WORKDIR /app
COPY . .

RUN npm install
EXPOSE 7655

CMD ["npm", "start"]
EOT

echo "✅ 正在创建 docker-compose.yml..."
cat <<EOT > docker-compose.yml
version: "3.9"
services:
  pulse-server:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: pulse
    restart: unless-stopped
    ports:
      - "7655:7655"
    env_file:
      - .env
    networks:
      - pulse_network

networks:
  pulse_network:
    driver: bridge
EOT

echo "🎉 所有文件创建完成，请前往 /volume1/docker/pulse 修改 .env 并运行："
echo "   docker-compose up -d"
