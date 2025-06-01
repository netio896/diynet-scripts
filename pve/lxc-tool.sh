#!/bin/bash

echo "📦 请选择要安装的 LXC 脚本:"
echo "1) AdGuardHome"
echo "2) Glances"
echo "3) UmbrelOS"
read -p "输入编号 [1-3]: " option

case $option in
  1)
    SCRIPT_URL="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/adguard.sh"
    ;;
  2)
    SCRIPT_URL="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/addon/glances.sh"
    ;;
  3)
    SCRIPT_URL="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/vm/umbrel-os-vm.sh"
    ;;
  *)
    echo "❌ 无效选择"; exit 1 ;;
esac

echo "🌐 请选择网络出口方式:"
echo "1) 使用 ShellClash 网关（192.168.88.15）"
echo "2) 使用默认路由"
read -p "输入编号 [1-2]: " netopt

USE_SHELLCLASH=0
if [ "$netopt" = "1" ]; then
  USE_SHELLCLASH=1
fi

# 创建 hook 脚本
HOOK_PATH="/etc/lxc/hooks/shellclash-gw.sh"
if [ "$USE_SHELLCLASH" = "1" ]; then
  cat <<EOF > $HOOK_PATH
#!/bin/bash
CTID="\$1"
ROOTFS="/var/lib/lxc/\$CTID/rootfs"
echo "ip route replace default via 192.168.88.15 dev eth0 onlink" >> "\${ROOTFS}/etc/rc.local"
echo 'nameserver 8.8.8.8' > "\${ROOTFS}/etc/resolv.conf"
chmod +x "\${ROOTFS}/etc/rc.local"
EOF
  chmod +x $HOOK_PATH
fi

# 执行安装脚本
bash -c "$(curl -fsSL $SCRIPT_URL)"

# 找到最近创建的 LXC 容器
LATEST_ID=$(pct list | awk 'NR>1 {print $1}' | sort -n | tail -n 1)

if [ "$USE_SHELLCLASH" = "1" ]; then
  echo "lxc.hook.autodev: $HOOK_PATH" >> /etc/pve/lxc/${LATEST_ID}.conf
  echo "✅ 已为容器 $LATEST_ID 添加 shellclash 网关 hook"
fi

echo "✅ 容器创建完成"
"""

# Save script to file
script_path = Path("/mnt/data/create_lxc_with_proxy_menu.sh")
script_path.write_text(script_content)
script_path.chmod(0o755)

script_path.name
