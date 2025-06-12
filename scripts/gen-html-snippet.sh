#!/bin/bash

# ✅ 自动切换到脚本所在目录的上一级
cd "$(dirname "$0")/.." || exit 1

# 自动扫描 scripts/ 和 pve/ 文件夹，生成 HTML 脚本块插入 docs/index.html
HTML="docs/index.html"
TMP="docs/index.tmp.html"

START_MARK="<!-- AUTO-INSERT-START -->"
END_MARK="<!-- AUTO-INSERT-END -->"

cmd_id=100
new_blocks=""

echo "🔍 开始扫描脚本文件..."

for script in $(find scripts pve -type f -name "*.sh" | sort); do
  title=$(basename "$script")
  url="https://gitspeed.diynet.club/netio896/diynet-scripts/main/$script"

  # 构建 HTML 代码块（注意要正确闭合 span）
  new_blocks+="  <div class=\"code-box\">
    <span id=\"cmd$cmd_id\">bash -c \\\"\$(curl -fsSL $url)\\\"</span>
    <button class=\\\"btn\\\" onclick=\\\"copy('cmd$cmd_id')\\\">复制</button>
  </div>
"
  ((cmd_id++))
done

# 插入 HTML 块到 index.html 中指定标记之间
awk -v new="$new_blocks" -v start="$START_MARK" -v end="$END_MARK" '
  $0 ~ start { print; print new; skip=1; next }
  $0 ~ end { skip=0 }
  skip != 1 { print }
' "$HTML" > "$TMP" && mv "$TMP" "$HTML"

echo "✅ 已将最新脚本插入 $HTML！"
