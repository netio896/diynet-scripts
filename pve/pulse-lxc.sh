cat <<'EOF' > install-pulse.sh
#!/bin/bash

CTID=118
GATEWAY="192.168.88.15"
TEMPLATE="debian-12-standard_12.7-1_amd64.tar.zst"
HOSTNAME="pulse"

# 自动选择可用存储池
for POOL in local-lvm local; do
  if pvesm status | grep -q "^$POOL" && pveam list $POOL | grep -q "$TEMPLATE"; then
    STORAGE=$POOL
    break
  elif pvesm status | grep -q "^$POOL"; then
    STORAGE=$POOL
    echo "===> 模板不存在，正在下载至 [$POOL]..."
    pveam update && pveam download $POOL $TEMPLATE
    break
  fi
done

# 检查是否找到存储池
if [ -z "$STORAGE" ]; then
  echo "❌ 未找到支持的存储池（local 或 local-lvm），请检查 PVE 存储配置！"
  exit 1
fi

# 自动寻找未被占用的 IP
for i in {100..199}; do
  ping -c1 -W1 192.168.88.$i &>/dev/null
  if [ $? -ne 0 ]; then
    IP="192.168.88.$i/24"
    break
  fi
done

# 创建容器
echo "===> 使用 [$STORAGE] 创建 Pulse 容器 [$CTID]，IP=$IP，网关=$GATEWAY"
pct create $CTID ${STORAGE}:vztmpl/$TEMPLATE \
  --hostname $HOSTNAME \
  --net0 name=eth0,bridge=vmbr0,ip=$IP,gw=$GATEWAY \
  --memory 1024 \
  --cores 1 \
  --unprivileged 1 \
  --rootfs $STORAGE:4 \
  --features nesting=1 \
  --start 1 || { echo "❌ 容器创建失败！请检查存储类型是否支持 rootfs"; exit 1; }

# 安装依赖
echo "===> 安装依赖中..."
pct exec $CTID -- bash -c "apt update && apt install -y curl sudo nodejs npm"

# 安装 Pulse
echo "===> 下载并安装 Pulse..."
pct exec $CTID -- bash -c "curl -fsSL https://raw.githubusercontent.com/rcourtman/Pulse/main/scripts/install-pulse.sh -o install.sh && chmod +x install.sh && ./install.sh"

# 成功提示
echo "✅ Pulse 安装完成，请访问：http://$(echo $IP | cut -d'/' -f1)"
EOF

bash install-pulse.sh
