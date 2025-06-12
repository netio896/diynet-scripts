cat <<'EOF' > install-stormbreaker.sh
#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "📦 更新 Termux 并安装依赖..."
pkg update -y && pkg upgrade -y
pkg install -y git python php curl wget unzip

echo "🌐 安装 Ngrok..."
wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
unzip -o ngrok.zip
chmod +x ngrok
mv ngrok $PREFIX/bin
rm -f ngrok.zip

echo "🔑 配置 Ngrok Token..."
ngrok config add-authtoken 2yPh1ke4JSzrBu9LqPBCSTIrzCA_6jTA9ki94yrep3aQ9FxbC

echo "🐍 安装 Storm-Breaker..."
git clone https://github.com/ultrasecurity/Storm-Breaker
cd Storm-Breaker
pip install --upgrade pip
pip install -r requirements.txt

echo "✅ 安装完成！你可以运行以下命令启动："
echo "-----------------------------------------"
echo "cd Storm-Breaker"
echo "python3 st.py"
echo "ngrok http 2525"
echo "-----------------------------------------"
EOF

chmod +x install-stormbreaker.sh
bash install-stormbreaker.sh
