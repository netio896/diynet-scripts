#!/bin/bash
clear
echo "🛠️ DiyNet 一键工具合集"
echo "============================="
echo "1. 🧰 通用工具脚本"
echo "2. 🖥️ PVE 容器部署脚本"
echo "3. 📦 群晖 Docker 项目部署"
echo "4. 退出"
echo "============================="
read -p "请选择分类 [1-4]: " category

case $category in
  1)
    echo "1) 安装常用工具"
    echo "2) 网络优化"
    echo "3) 网络优化工具（缅甸环境推荐）"
    echo "4) Cloudflare DDNS 安装"
    read -p "选择脚本编号：" tool
    [[ $tool == 1 ]] && bash <(curl -sSL https://gitspeed.diynet.club/https://raw.githubusercontent.com/netio896/diynet-scripts/main/scripts/base-tools.sh)
    [[ $tool == 2 ]] && bash <(curl -sSL https://gitspeed.diynet.club/https://raw.githubusercontent.com/netio896/diynet-scripts/main/scripts/net-optimize.sh)
    [[ $tool == 3 ]] && bash <(curl -sSL https://gitspeed.diynet.club/https://raw.githubusercontent.com/netio896/diynet-scripts/main/scripts/net-optimize.sh)
    echo "4) Cloudflare DDNS 安装"
    [[ $tool == 4 ]] && bash <(curl -sSL https://gitspeed.diynet.club/https://raw.githubusercontent.com/netio896/diynet-scripts/main/install/cloudflare-ddns-install.sh)
    ;;
  2)
    echo "1) 创建 Pulse 容器"
    echo "2) 部署 AdGuardHome 容器"
    [[ $tool == 2 ]] && bash <(curl -sSL https://gitspeed.diynet.club/https://raw.githubusercontent.com/netio896/diynet-scripts/main/pve/install-adguardhome.sh)
    read -p "选择脚本编号：" tool
    [[ $tool == 1 ]] && bash <(curl -sSL https://gitspeed.diynet.club/https://raw.githubusercontent.com/netio896/diynet-scripts/main/pve/create-lxc-pulse.sh)
    [[ $tool == 2 ]] && bash <(curl -sSL https://gitspeed.diynet.club/https://raw.githubusercontent.com/netio896/diynet-scripts/main/pve/install-adguardhome.sh)
    ;;
  3)
    echo "1) 部署 Pulse Server 到群晖"
    read -p "选择脚本编号：" tool
    [[ $tool == 1 ]] && bash <(curl -sSL https://raw.githubusercontent.com/netio896/diynet-scripts/main/scripts/deploy-pulse-server.sh)
    ;;
  *)
    echo "👋 再见"
    ;;
esac
