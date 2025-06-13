#!/bin/bash

echo "🚀 开始安装 proxychains4 并配置 SOCKS5 代理..."

# 安装 proxychains4
sudo apt update && sudo apt install -y proxychains4

# 设置 SOCKS5 代理为 192.168.88.123:9050
sudo sed -i 's@^socks[45].*@socks5 192.168.88.123 9050@' /etc/proxychains4.conf

# 输出提示
echo -e '\n✅ SOCKS5 代理设置完成，使用示例：\n\n  proxychains4 curl https://check.torproject.org\n'

# 添加 alias 到 ~/.bashrc（防止重复添加）
grep -q "proxychains4 curl" ~/.bashrc || cat <<EOF >> ~/.bashrc

# Proxychains4 快捷命令
alias curl='proxychains4 curl'
alias wget='proxychains4 wget'
alias git='proxychains4 git'
EOF

# 立即生效
source ~/.bashrc

echo "✅ 安装与配置完成，请使用 curl/git/wget 自动走代理通道"
