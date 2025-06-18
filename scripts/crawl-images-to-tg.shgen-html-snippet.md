当然可以，以下是整理好的 .md 格式文档，适合保存为教程或放入 GitHub 项目文档中使用：


---

🖼️ Telegram 图像爬取并推送工具

本工具支持从网页中提取图片地址并通过 Telegram Bot 自动推送，支持 SOCKS5 代理和多链接输入，适合部署在服务器上快速分享图片内容。


---

✅ 环境准备与依赖安装

apt update -y && apt install -y python3 python3-pip
pip3 install --upgrade requests[socks] Pillow


---

✅ 脚本内容 crawl-images-to-tg.sh

cat << 'EOF' > crawl-images-to-tg.sh
#!/bin/bash

# === 配置参数 ===
TG_BOT_TOKEN="7315770854:AAHQFcIl_7_AQoWxviDLqqtSU63W-EoVqG0"
TG_CHAT_ID="904019805"
SOCKS5_PROXY="socks5h://192.168.88.123:9050"
SAVE_DIR="images"
TMP_SCRIPT="/tmp/crawl_and_push.py"

# === 输入链接 ===
echo "🌐 请输入要爬取的网页链接（多个链接用空格分隔）："
read -a URL_LIST
mkdir -p "$SAVE_DIR"

# === Python 执行脚本 ===
cat <<PYEOF > "$TMP_SCRIPT"
import requests, os, re, sys
from PIL import Image
from io import BytesIO

headers = {"User-Agent": "Mozilla/5.0"}
tg_bot_token = "$TG_BOT_TOKEN"
tg_chat_id = "$TG_CHAT_ID"
save_dir = "$SAVE_DIR"
proxies = {"http": "$SOCKS5_PROXY", "https": "$SOCKS5_PROXY"}
suffix_try = ["orig.jpg", "1.jpg", "2.jpg", "large.jpg", "high.jpg", "0.jpg"]

os.makedirs(save_dir, exist_ok=True)

for url in sys.argv[1:]:
    print(f"📥 正在请求网页内容：{url}")
    try:
        html = requests.get(url, headers=headers, timeout=15).text
        img_urls = re.findall(r'https?://[^\s"\'<>]+\\.(?:jpg|jpeg|png)', html, re.IGNORECASE)
        print(f"✅ 共找到 {len(img_urls)} 张图")
    except Exception as e:
        print(f"❌ 访问失败：{e}")
        continue

    for i, img_url in enumerate(img_urls):
        base = img_url.rsplit('/', 1)[0]
        best = ""
        max_px = 0

        for suffix in suffix_try:
            test_url = f"{base}/{suffix}"
            try:
                r = requests.get(test_url, timeout=5)
                if r.status_code == 200:
                    img = Image.open(BytesIO(r.content))
                    pixels = img.width * img.height
                    if pixels > max_px:
                        max_px = pixels
                        best = test_url
            except:
                continue

        if not best:
            best = img_url
            print(f"[i] 使用原图推送：{best}")
        else:
            print(f"[✓] 推送第{i+1}张高清图：{best}")

        try:
            tg_api = f"https://api.telegram.org/bot{tg_bot_token}/sendPhoto"
            resp = requests.post(tg_api, data={'chat_id': tg_chat_id, 'photo': best}, proxies=proxies)
            if resp.status_code != 200:
                print(f"[!] 推送失败：{resp.status_code} {resp.text}")
        except Exception as e:
            print(f"[!] 网络错误：{e}")

print("✅ 所有任务完成")
PYEOF

python3 "$TMP_SCRIPT" "${URL_LIST[@]}"
EOF

chmod +x crawl-images-to-tg.sh


---

✅ 使用方法

./crawl-images-to-tg.sh

然后按提示输入多个网页链接，空格分隔，例如：

🔗 URL: https://example.com/page1 https://example.com/page2


---

✅ 示例输出

📥 正在请求网页内容：https://example.com
✅ 共找到 3 张图
[✓] 推送第1张高清图：https://example.com/img1.jpg
[✓] 推送第2张高清图：https://example.com/img2.jpg
✅ 所有任务

