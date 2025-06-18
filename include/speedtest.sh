#!/data/data/com.termux/files/usr/bin/bash

echo -e "\n📶 当前网络测速中..."

if command -v speedtest-go >/dev/null 2>&1; then
    speedtest-go
else
    echo -e "❌ 未检测到 speedtest-go 命令，请先安装。"
    echo -e "🔧 你可以访问 https://github.com/showwin/speedtest-go/releases 下载对应平台版本，"
    echo -e "或使用 Git 加速链接："
    echo -e "➡️  https://gitspeed.diynet.club/showwin/speedtest-go/releases"
fi

read -n 1 -s -r -p $'\n按任意键返回菜单...'
