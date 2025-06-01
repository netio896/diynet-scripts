#!/bin/bash
clear
echo "🛠️ DiyNet 一 键 工 具 合 集"
echo "============================="

# 定义脚本目录分类（自动可扩展）
CATEGORIES=("scripts:🧰 通 用 工 具" "pve:🖥️ PVE 容 器 部 署" "nas:📦 群晖 Docker 项 目")
i=1
for entry in "${CATEGORIES[@]}"; do
  desc=$(echo "$entry" | cut -d: -f2)
  echo "$i. $desc"
  ((i++))
done
echo "$i. 退 出"
echo "============================="

read -p "请 选 择 分 类  [1-$i]: " choice
[[ "$choice" == "$i" ]] && echo "👋 已退出" && exit 0

# 目录选择
dir=$(echo "${CATEGORIES[$((choice-1))]}" | cut -d: -f1)

# 确认目录存在
[[ ! -d "$dir" ]] && echo "❌ 无法访问目录 $dir" && exit 1

cd "$dir" || exit 1
echo ""
echo "📂 当前目录：$dir"
echo "📄 可 用 脚 本："

i=1
declare -a SCRIPTS
for f in *.sh; do
  [[ ! -f "$f" ]] && continue
  echo "$i) $f"
  SCRIPTS+=("$f")
  ((i++))
done

if [[ ${#SCRIPTS[@]} -eq 0 ]]; then
  echo "⚠️ 当前目录下没有任何 .sh 脚本。"
  exit 0
fi

echo ""
read -p "选 择 脚 本 编 号 ：" num
index=$((num - 1))
selected="${SCRIPTS[$index]}"

echo ""
echo "🚀 正在执行：$selected"
echo "============================="
bash "$selected"
