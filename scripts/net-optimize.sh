#!/bin/bash
set -e

# 网络优化工具，提供启用/禁用 BBR 等功能
if [[ $(id -u) -ne 0 ]]; then
  echo "❌ 请使用 root 权限运行此脚本" >&2
  exit 1
fi

CONF_FILE="/etc/sysctl.d/99-bbr.conf"

enable_bbr() {
  cat <<'EOT' >"$CONF_FILE"
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOT
  sysctl -p "$CONF_FILE" >/dev/null
  echo "✅ 已启用 BBR"
}

disable_bbr() {
  rm -f "$CONF_FILE"
  sysctl -p >/dev/null
  echo "✅ 已禁用 BBR"
}

check_status() {
  algo=$(sysctl -n net.ipv4.tcp_congestion_control)
  echo "当前拥塞控制算法: $algo"
}

show_menu() {
  cat <<'MENU'
1) 启用 BBR
2) 禁用 BBR
3) 查看状态
0) 退出
MENU
}

while true; do
  show_menu
  read -rp "请选择: " choice
  case "$choice" in
    1) enable_bbr ;;
    2) disable_bbr ;;
    3) check_status ;;
    0) break ;;
    *) echo "无效选择" ;;
  esac
  echo
done
