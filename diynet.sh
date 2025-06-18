#!/data/data/com.termux/files/usr/bin/bash

========== 自动识别系统类型 ==========

os_type=""
if [ -f /etc/os-release ]; then
. /etc/os-release
os_type=$ID
elif uname -a | grep -qi termux; then
os_type="termux"
elif uname -a | grep -qi openwrt; then
os_type="openwrt"
else
os_type=$(uname -s | tr A-Z a-z)
fi

========== 安装命令自动适配 ==========

install_cmd() {
case "$os_type" in
ubuntu|debian) apt update -y && apt install -y "$@" ;;
alpine) apk add --no-cache "$@" ;;
openwrt) opkg update && opkg install "$@" ;;
termux) pkg update -y && pkg install -y "$@" ;;
) echo "❌ 无法识别系统类型 $os_type，无法安装 $"; return 1 ;;
esac
}

ensure() {
for cmd in "$@"; do
if ! command -v "$cmd" >/dev/null 2>&1; then
echo "⚙️ 自动安装缺失命令：$cmd"
install_cmd "$cmd"
fi
done
}

========== 主菜单 ==========

while true; do
clear
echo "========== 🌟 DiyNet Termux 工具菜单 🌟 =========="
echo "1. 更新 Termux 包"
echo "2. 启动 SSH 服务（显示用户名和 IP）"
echo "3. 启动 PHP 本地服务器（端口8080）"
echo "4. 上传文件到 Telegram"
echo "5. 查看公网 IP"
echo "6. 一键测速（备用 speedtest-go）"
echo "7. 安装常用网络工具包"
echo "9. 修复 DNS 故障"
echo "10. Clash 状态检测与重启"
echo "11. 打开 ZeroTier / Tailscale 面板"
echo "12. 测试端口连通性"
echo "0. 退出"
echo "============================================"
echo -n "请输入编号："
read choice

case "$choice" in
1)
echo -e "\n📦 正在更新 Termux..."
pkg update && pkg upgrade -y
read -n 1 -s -r -p $'\n✅ 更新完成！按任意键返回菜单...'
;;
2)
echo -e "\n🔐 正在启动 SSH 服务..."
ensure openssh net-tools
sshd
username=$(whoami)
ipaddr=$(ip a | awk '/inet 192/ {print $2}' | cut -d/ -f1 | head -n 1)
[ -z "$ipaddr" ] && ipaddr=$(hostname -I | tr " " "\n" | grep ^192 | head -n1)
echo -e "\n✅ SSH 已启动，默认端口：8022"
echo -e "🧑 用户名：$username"
echo -e "🌐 本机 IP：$ipaddr"
echo -e "📥 登录命令：ssh $username@$ipaddr -p 8022"
read -n 1 -s -r -p $'\n按任意键返回菜单...'
;;
3)
echo -e "\n🌐 启动 PHP 本地服务器（8080）..."
ensure php
php -S 0.0.0.0:8080
;;
4)
bash ./upload-to-telegram.sh
;;
5)
echo -e "\n🌍 正在获取公网 IP..."
curl -s https://ipinfo.io/ip || curl -s ifconfig.me
read -n 1 -s -r -p $'\n按任意键返回菜单...'
;;
6)
echo -e "\n📶 当前网络测速中..."
chmod +x ~/speedtest-go 2>/dev/null
ln -sf ~/speedtest-go $PREFIX/bin/speedtest-go
speedtest-go || echo -e "\n❌ 测速失败，请检查 speedtest-go 是否已正确解压"
read -n 1 -s -r -p $'\n按任意键返回菜单...'
;;
7)
echo -e "\n📦 安装常用网络工具..."
ensure curl wget net-tools iproute2 dnsutils
echo "✅ 工具安装完成！"
read -n 1 -s -r -p $'\n按任意键返回菜单...'
;;
9)
echo -e "\n🧰 正在修复 DNS..."
echo "nameserver 8.8.8.8" > $PREFIX/etc/resolv.conf
echo "nameserver 1.1.1.1" >> $PREFIX/etc/resolv.conf
echo "✅ 已恢复为 Google DNS"
read -n 1 -s -r -p $'\n按任意键返回菜单...'
;;
10)
echo -e "\n🌀 检查 Clash 状态..."
pgrep clash > /dev/null && echo "✅ Clash 正在运行" || echo "⚠️ Clash 未运行"
read -n 1 -s -r -p $'\n按任意键返回菜单...'
;;
11)
echo -e "\n🌐 打开 ZeroTier / Tailscale 面板..."
am start -a android.intent.action.VIEW -d "http://127.0.0.1:4040" >/dev/null 2>&1 || echo "⚠️ 无法打开本地面板"
read -n 1 -s -r -p $'\n按任意键返回菜单...'
;;
12)
echo -n "请输入要测试的目标 IP 或域名（如 8.8.8.8:443）："
read target
nc -zv $(echo $target | sed 's/:/ /') && echo "✅ 端口连通" || echo "❌ 无法连接"
read -n 1 -s -r -p $'\n按任意键返回菜单...'
;;
0)
echo "👋 再见！"
exit 0
;;
*)
echo "❌ 无效的选项，请重新输入。"
sleep 1
;;
esac
done
