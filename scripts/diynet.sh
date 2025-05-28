#!/bin/bash
clear
echo "============================="
echo "🛠️ DiyNet 一键工具合集"
echo "============================="
echo "1. 安装常用工具"
echo "2. 网络优化设置"
echo "3. 退出"
echo "-----------------------------"
read -p "请选择 [1-3]: " choice

case $choice in
  1)
    bash <(curl -sSL https://raw.githubusercontent.com/netio896/diynet-scripts/main/scripts/base-tools.sh)
    ;;
  2)
    bash <(curl -sSL https://raw.githubusercontent.com/netio896/diynet-scripts/main/scripts/net-optimize.sh)
    ;;
  *)
    echo "👋 再见啦！"
    ;;
esac
