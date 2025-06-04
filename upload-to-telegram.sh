#!/bin/bash
# 通用 Telegram 文件上传脚本（适配 Termux / VPS）

# === 配置 ===
TOKEN="7315770854:AAHQFcIl_7_AQoWxviDLqqtSU63W-EoVqG0"
CHAT_ID="904019805"

# === 输入参数 ===
FILE="$1"

# === 校验 ===
if [ -z "$FILE" ]; then
  echo "❌ 请输入要上传的文件路径"
  echo "用法: bash upload-to-telegram.sh /path/to/file.sh"
  exit 1
fi

if [ ! -f "$FILE" ]; then
  echo "❌ 找不到文件: $FILE"
  exit 1
fi

# === 上传 ===
echo "🚀 正在上传 $FILE 到 Telegram..."
curl -s -F "document=@${FILE}" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=${CHAT_ID}" \
  && echo "✅ 上传成功！" \
  || echo "❌ 上传失败，请检查网络或 Token"
