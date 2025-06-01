#!/bin/bash
# 自动扫描 scripts/ 和 pve/ 文件夹，生成 HTML 脚本块插入 docs/index.html
# 使用标记 <!-- AUTO-INSERT-START --> ~ <!-- AUTO-INSERT-END -->

HTML="docs/index.html"
TMP="docs/index.tmp.html"

START_MARK="<!-- AUTO-INSERT-START -->"
END_MARK="<!-- AUTO-INSERT-END -->"

cmd_id=100
new_blocks=""

echo "🔍 开始扫描脚本文件..."

for script in $(find scripts pve -type f -name "*.sh" | sort); do
  # 提取文件名
  title=$(basename "$script")
  # 构建加速 URL
  url="https://gitspeed.diynet.club/netio896/diynet-scripts/main/$script"

  # 构建 HTML 代码块
  new_blocks+="  <div class=\"code-box\">
    <span id=\"cmd$cmd_id\">bash -c \\\"\$(curl -fsSL $url)\\\"</span>
    <button class=\\\"btn\\\" onclick=\\\"copy('cmd$cmd_id')\\\">复制</button>
  </div>
"
  ((cmd_id++))
done

# 插入 HTML
awk -v new="$new_blocks" -v start="$START_MARK" -v end="$END_MARK" '
  $0 ~ start { print; print new; skip=1; next }
  $0 ~ end { skip=0 }
  skip != 1 { print }
' "$HTML" > "$TMP" && mv "$TMP" "$HTML"

echo "✅ 已将最新脚本插入 docs/index.html！"
