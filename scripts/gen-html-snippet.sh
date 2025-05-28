#!/bin/bash

echo "🔧 请输入命令说明（例如：安装 AdGuardHome）："
read desc
echo "📦 请输入脚本原始链接（GitHub raw 形式）："
read url

# 自动生成唯一 ID
id="cmd$(date +%s | tail -c 4)$((RANDOM % 90 + 10))"

echo
echo "✅ 复制下面这段 HTML 到你的页面："
echo "------------------------------------------------------"
cat <<HTML
<div class="code-box">
  <span id="$id">bash -c "\$(curl -fsSL $url)"</span>
  <button class="btn" onclick="copy('$id')">复制</button>
</div>
<!-- $desc -->
HTML
echo "------------------------------------------------------"
