#!/bin/bash
echo "🔧 正在安装常用工具..."
apt update && apt install -y curl wget vim git net-tools
echo "✅ 安装完成！"
