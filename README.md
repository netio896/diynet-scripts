# DiyNet 脚本仓库使用指南

本教程适用于基于 `diynet-scripts` 项目的 GitHub 仓库，帮助你轻松添加新的 Shell 工具脚本，并更新网页入口（GitHub Pages）展示。

---

## 🧰 一、创建新的工具脚本

以 `ShellClash` 为例：

```bash
# 1. 创建目录（推荐放在 scripts/linux 下）
mkdir -p scripts/linux

# 2. 创建安装脚本
cat <<'EOF' > scripts/linux/shellclash-install.sh
#!/bin/bash
bash -c "$(curl -fsSL https://gitspeed.diynet.club/https://raw.githubusercontent.com/juewuy/ShellCrash/master/install.sh)"
EOF

# 3. 赋予执行权限
chmod +x scripts/linux/shellclash-install.sh
```

---

## 🖥️ 二、添加到网页入口（docs/index.html）

在 `<div class="section">` 对应分类中插入如下 HTML 片段：

```html
<div class="code-box">
  <span id="cmd10">bash -c "$(curl -fsSL https://raw.githubusercontent.com/netio896/diynet-scripts/main/scripts/linux/shellclash-install.sh)"</span>
  <button class="btn" onclick="copy('cmd10')">复制</button>
</div>
<!-- 安装 ShellClash（终端网络加速工具） -->
```

---

## 🚀 三、Git 推送流程（标准操作）

```bash
# 添加变动文件
git add .

# 提交记录（请写明操作内容）
git commit -m "添加 shellclash 工具脚本及页面按钮"

# 拉取远程更新避免冲突（建议）
git pull --rebase

# 推送到 GitHub
git push
```

---

## 🔁 四、预览地址更新

如果你开启了 GitHub Pages 且使用了自定义域名：
- 访问地址通常为：`https://scripts.diynet.club`
- 或 `https://<用户名>.github.io/<仓库名>/`

页面更新后大约 10~30 秒内生效，可刷新查看是否生效 ✅

---

## 🧩 附录：脚本目录规范建议

| 类型         | 路径                | 示例                             |
|--------------|---------------------|----------------------------------|
| 通用系统工具 | `scripts/linux/`     | shellclash-install.sh            |
| PVE 脚本     | `pve/`              | install-adguardhome.sh           |
| 群晖脚本     | `nas/pulse-server/` | generate-pulse-server.sh         |
| 页面资源     | `docs/`             | index.html、CNAME                |

