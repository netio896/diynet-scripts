#!/bin/bash

CTID=119
GATEWAY="192.168.88.15"
TEMPLATE="debian-12-standard_12.7-1_amd64.tar.zst"
HOSTNAME="adghome"

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

if [ -z "$STORAGE" ]; then
  echo "❌ 未找到支持的存储池（local 或 local-lvm）"
  exit 1
fi

# 自动跳过已占用 IP
for i in {100..199}; do
  ping -c1 -W1 192.168.88.$i &>/dev/null
  if [ $? -ne 0 ]; then
    IP="192.168.88.$i/24"
    break
  fi
done

# 创建容器
echo "===> 创建 AdGuardHome 容器 [$CTID]，IP=$IP，网关=$GATEWAY"
pct create $CTID ${STORAGE}:vztmpl/$TEMPLATE \
  --hostname $HOSTNAME \
  --net0 name=eth0,bridge=vmbr0,ip=$IP,gw=$GATEWAY \
  --memory 512 \
  --cores 1 \
  --unprivileged 1 \
  --rootfs $STORAGE:4 \
  --features nesting=1 \
  --start 1 || { echo "❌ 容器创建失败！"; exit 1; }

# 安装 AdGuardHome
pct exec $CTID -- bash -c "
  apt update &&
  apt install -y curl sudo && 
  curl -s -S -L https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_amd64.tar.gz -o adgh.tar.gz &&
  tar -xzf adgh.tar.gz &&
  cd AdGuardHome &&
  ./AdGuardHome -s install
"

# 成功提示
echo "✅ AdGuardHome 安装完成，请访问：http://$(echo $IP | cut -d'/' -f1):3000"
