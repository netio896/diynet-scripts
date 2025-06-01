#!/bin/bash

ShellCrash 多源安装脚本合集

Author: Sanda

Usage: bash shellcrash-install.sh

clear echo "\n📦 ShellCrash 多平台安装命令合集" echo "====================================" echo "请选择安装源：" echo "1. Linux 安装 - jsDelivr" echo "2. Linux 安装 - gh.jwsc.eu.org" echo "3. 路由器 curl 安装 - GitHub" echo "4. 路由器 curl 安装 - jsDelivr" echo "5. 路由器 curl 安装 - 私人源" echo "6. 路由器 wget 安装 - GitHub" echo "7. 路由器 wget 安装 - jsDelivr" echo "8. 路由器 wget 安装 - http 私人源" echo "9. Docker/虚拟机 Alpine 安装" echo "====================================" read -p "输入数字选择 [1-9]: " opt

echo -e "\n📥 执行中...\n"

case $opt in 1) sudo -i bash -c "export url='https://fastly.jsdelivr.net/gh/juewuy/ShellCrash@master'; wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh && bash /tmp/install.sh && source /etc/profile &>/dev/null" ;; 2) sudo -i bash -c "export url='https://gh.jwsc.eu.org/master'; bash -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile &>/dev/null" ;; 3) export url='https://raw.githubusercontent.com/juewuy/ShellCrash/master' sh -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile &>/dev/null ;; 4) export url='https://fastly.jsdelivr.net/gh/juewuy/ShellCrash@master' sh -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile &>/dev/null ;; 5) export url='https://gh.jwsc.eu.org/master' sh -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile &>/dev/null ;; 6) export url='https://raw.githubusercontent.com/juewuy/ShellCrash/master' wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh && sh /tmp/install.sh && source /etc/profile &>/dev/null ;; 7) export url='https://fastly.jsdelivr.net/gh/juewuy/ShellCrash@master' wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh && sh /tmp/install.sh && source /etc/profile &>/dev/null ;; 8) export url='http://t.jwsc.eu.org' wget -q -O /tmp/install.sh $url/install.sh && sh /tmp/install.sh && source /etc/profile &>/dev/null ;; 9) echo "请确保已安装 Docker 环境：" echo "docker run -d --name ShellCrash alpine sleep infinity" echo "docker exec -it ShellCrash sh" echo "apk add curl nftables" echo "export url='https://fastly.jsdelivr.net/gh/juewuy/ShellCrash@master'" echo "sh -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile" ;; *) echo "❌ 输入有误，未执行安装。" ;; esac

echo -e "\n✅ 执行完毕，请根据提示继续配置使用。"

本脚本存放建议路径：scripts/linux/shellclash-install.sh
