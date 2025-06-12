#!/bin/bash
# 一键部署 VM 模板（DSM/OpenWRT/Windows 等）

set -e

# === Telegram 可选通知 ===
TELEGRAM_BOT_TOKEN="8002240208:AAEoT7F7EmZJ4wYwuI8It_KTkAg6guU55z0"
CHAT_ID="904019805"

# === 参数解析 ===
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --vmid) VMID="$2"; shift ;;
    --name) VMNAME="$2"; shift ;;
    --image) IMAGE="$2"; shift ;;
    --ip) STATIC_IP="$2"; shift ;;
    --onboot) ONBOOT="$2"; shift ;;
    *) echo "❌ 未知参数: $1" && exit 1 ;;
  esac
  shift
done

if [[ -z "$VMID" || -z "$VMNAME" || -z "$IMAGE" ]]; then
  echo "❗ 用法示例："
  echo "  bash deploy-vm-template.sh --vmid 200 --name DSM-Customer --image ./dsm-system.qcow2 --onboot yes"
  exit 1
fi

ONBOOT=${ONBOOT:-yes}
BRIDGE_IFACE="vmbr0"
DISK_STORAGE="local-lvm"
LOG_FILE="/var/log/vm-deploy-$VMID.log"

echo "📦 正在部署 VM（VMID: $VMID）..."
echo "🖼️ 镜像: $IMAGE"

qm create "$VMID" --name "$VMNAME" --memory 4096 --cores 2 \
  --net0 virtio,bridge=$BRIDGE_IFACE --bios ovmf --ostype l26 --onboot $ONBOOT

qm importdisk "$VMID" "$IMAGE" "$DISK_STORAGE"
qm set "$VMID" --sata0 "$DISK_STORAGE:vm-${VMID}-disk-0"
qm set "$VMID" --boot order=sata0
qm start "$VMID"

send_telegram() {
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d "chat_id=${CHAT_ID}" \
    -d "text=✅ 新 VM 已部署完成：\n名称：$VMNAME\nVMID：$VMID\n镜像：$(basename $IMAGE)\n时间：$(date +'%F %T')" > /dev/null
}

echo "✅ [$VMID] $VMNAME 部署完成 @ $(date)" | tee -a "$LOG_FILE"
send_telegram

if [[ -n "$STATIC_IP" ]]; then
  echo "⚠️ 静态 IP 预设：$STATIC_IP（需在系统内设置）"
fi

exit 0
