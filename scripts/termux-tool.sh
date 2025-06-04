#!/data/data/com.termux/files/usr/bin/bash

# Termux 常用命令菜单工具 by ChatGPT 为 Sanda 定制

while true; do
  clear
  echo -e "\e[1;36m🌟 Termux 常用功能菜单 🌟\e[0m"
  echo "请选择要执行的功能："
  echo
  echo "📱 设备信息"
  echo "  1) 电池状态"
  echo "  2) 当前 WiFi 信息"
  echo "  3) 获取 GPS 定位"
  echo "  4) 获取设备信息"
  echo
  echo "🔔 通知与交互"
  echo "  5) 弹出 Toast 提示"
  echo "  6) 发送系统通知"
  echo "  7) 文字转语音（TTS）"
  echo
  echo "📤 剪贴板 & 分享"
  echo "  8) 获取剪贴板内容"
  echo "  9) 设置剪贴板内容"
  echo " 10) 分享文本到其他 App"
  echo
  echo "📷 硬件控制"
  echo " 11) 打开手电筒"
  echo " 12) 关闭手电筒"
  echo " 13) 拍照保存"
  echo " 14) 震动 300 毫秒"
  echo
  echo "📨 通信功能"
  echo " 15) 发送短信"
  echo " 16) 拨打电话"
  echo
  echo "📁 存储与下载"
  echo " 17) 下载文件"
  echo " 18) 授权存储访问"
  echo
  echo "  0) 退出"
  echo

  read -p "请输入数字选择功能: " choice
  case "$choice" in
    1) termux-battery-status | jq ;;
    2) termux-wifi-connectioninfo | jq ;;
    3) termux-location | jq ;;
    4) termux-telephony-deviceinfo | jq ;;
    5) read -p "请输入提示内容: " msg; termux-toast "$msg" ;;
    6) read -p "通知标题: " title; read -p "通知内容: " content; termux-notification --title "$title" --content "$content" ;;
    7) read -p "请输入要朗读的文字: " say; termux-tts-speak "$say" ;;
    8) termux-clipboard-get ;;
    9) read -p "请输入要复制的内容: " clip; echo "$clip" | termux-clipboard-set ;;
    10) read -p "请输入要分享的文本: " share; termux-share -a send -c "$share" ;;
    11) termux-torch on ;;
    12) termux-torch off ;;
    13) termux-camera-photo -c 0 -o photo_$(date +%s).jpg && echo "✅ 已保存照片" ;;
    14) termux-vibrate -d 300 ;;
    15) read -p "手机号: " num; read -p "短信内容: " msg; termux-sms-send -n "$num" "$msg" ;;
    16) read -p "要拨打的号码: " callnum; termux-telephony-call "$callnum" ;;
    17) read -p "请输入 URL: " url; termux-download "$url" ;;
    18) termux-setup-storage ;;
    0) echo "已退出，再见～"; exit 0 ;;
    *) echo "❌ 无效选项"; sleep 1 ;;
  esac

  echo
  read -p "按回车键返回菜单..." temp
done
