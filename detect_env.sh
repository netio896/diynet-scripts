#!/bin/bash

echo "正在检测您的系统环境..."
echo "---"

# 1. 检测是否是 Termux 环境
if [ -n "$TERMUX_VERSION" ]; then
    echo "识别到：您正在使用 **Termux** 环境。"
    echo ""
    echo "在 Termux 中，没有传统的桌面菜单。您可以考虑以下方法来方便使用您的工具："
    echo "1. **创建别名 (Alias)**：将常用脚本命令添加到您的 `~/.bashrc` 或 `~/.zshrc` 文件中，例如："
    echo "   echo \"alias mytool='~/storage/downloads/diynet-scripts/diynet-scripts/scripts/your-script.sh'\" >> ~/.bashrc"
    echo "   source ~/.bashrc"
    echo "   之后直接输入 `mytool` 即可运行脚本。"
    echo "2. **创建主菜单脚本**：编写一个主脚本，列出所有工具并允许您通过数字选择运行，例如："
    echo "   创建一个 `main_menu.sh` 文件，内容如下："
    echo "   #!/bin/bash"
    echo "   echo \"请选择一个工具:\""
    echo "   echo \"1. Termux 工具\""
    echo "   echo \"2. 网络优化\""
    echo "   read -p \"请输入编号: \" choice"
    echo "   case \$choice in"
    echo "       1) ~/storage/downloads/diynet-scripts/diynet-scripts/scripts/termux-tool.sh ;;"
    echo "       2) ~/storage/downloads/diynet-scripts/diynet-scripts/scripts/net-optimize.sh ;;"
    echo "       *) echo \"无效的选择。\" ;;"
    echo "   esac"
    echo "   然后给 `main_menu.sh` 添加执行权限并运行它。"
    echo ""
    echo "建议：在 Termux 中，别名和主菜单脚本是最常用的方法，方便您在命令行中快速启动工具。"

# 2. 检测 Linux 桌面环境
elif command -v xdg-open &>/dev/null; then
    echo "识别到：您可能正在使用 **Linux 桌面环境** (如 GNOME, KDE, XFCE 等)。"
    echo ""
    echo "在 Linux 桌面环境中，通常通过创建 **.desktop 文件** 将工具添加到菜单栏。以下是通用步骤："
    echo "1. **确定脚本的完整路径**：例如，您的 `termux-tool.sh` 脚本的完整路径是："
    echo "   `/home/u0_a1470/storage/downloads/diynet-scripts/diynet-scripts/scripts/termux-tool.sh`"
    echo "2. **创建 .desktop 文件**：在 `~/.local/share/applications/` 目录下创建一个新文件，例如 `my-termux-tool.desktop`。"
    echo "   文件内容示例如下："
    echo "   \`\`\`desktop"
    echo "   [Desktop Entry]"
    echo "   Version=1.0"
    echo "   Type=Application"
    echo "   Name=我的Termux工具"
    echo "   Comment=运行特定的Termux工具脚本"
    echo "   Exec=/home/u0_a1470/storage/downloads/diynet-scripts/diynet-scripts/scripts/termux-tool.sh"
    echo "   Icon=utilities-terminal  # 可选：您可以使用系统图标或指定图片路径"
    echo "   Terminal=true            # 如果脚本需要在终端中运行，请设置为 true"
    echo "   Categories=Utility;Tools;"
    echo "   \`\`\`"
    echo "   请将 `Exec=` 后面的路径替换为您脚本的实际完整路径。"
    echo "3. **赋予执行权限**：打开终端，进入 `~/.local/share/applications/` 目录，然后运行："
    echo "   `chmod +x my-termux-tool.desktop`"
    echo "4. **更新菜单**：大多数桌面环境会自动刷新菜单。如果没有，您可以尝试注销并重新登录。"
    echo ""
    echo "对于 `scripts` 目录下的其他工具，您可以为每个脚本重复上述步骤，创建单独的 `.desktop` 文件。"

# 3. 无法识别环境
else
    echo "抱歉，无法准确识别您的系统环境。"
    echo "您可能正在使用一个不常见的环境，或者脚本未能检测到关键环境变量。"
    echo ""
    echo "如果您在 **Windows** 上使用 WSL (Windows Subsystem for Linux)，则通常也遵循 Linux 桌面的方法。"
    echo "如果您在 **macOS** 上，您可以尝试创建 Automator 脚本或修改应用启动器。"
    echo ""
    echo "如果您能提供更多关于您当前操作环境的信息（例如，是否有图形界面，是否在手机上使用等），我可以给出更精确的建议。"
fi

echo "---"
