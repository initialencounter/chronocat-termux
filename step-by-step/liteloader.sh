# 安装Linux QQ
# payload=$(curl https://im.qq.com/rainbow/linuxQQDownload | grep -oP "var params= \K\{.*\}(?=;)")
# amd64_url=$(jq -r .x64DownloadUrl.deb <<< "$payload")
# arm64_url=$(jq -r .armDownloadUrl.deb <<< "$payload")
curl -L -o /root/linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.12_240927_arm64_01.deb
dpkg -i /root/linuxqq.deb 
apt-get -f install -y
rm /root/linuxqq.deb

# 下载LiteLoader 1.1.1
curl -L -o /tmp/LiteLoaderQQNT.zip https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/1.2.2/LiteLoaderQQNT.zip
unzip /tmp/LiteLoaderQQNT.zip -d /LiteLoader
echo 'require("/LiteLoader");' > /opt/QQ/resources/app/app_launcher/llqqnt.js
sed -i 's|"main": "[^"]*"|"main": "./app_launcher/llqqnt.js"|' /opt/QQ/resources/app/package.json

# 安装 whale
curl -L -o /tmp/whale.zip https://github.com/initialencounter/whale/releases/download/v0.1.1/whale.zip
mkdir -p /LiteLoader/plugins/whale
unzip /tmp/whale.zip -d /LiteLoader/plugins/whale