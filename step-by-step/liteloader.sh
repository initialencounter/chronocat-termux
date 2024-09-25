# 安装Linux QQ
# payload=$(curl https://im.qq.com/rainbow/linuxQQDownload | grep -oP "var params= \K\{.*\}(?=;)")
# amd64_url=$(jq -r .x64DownloadUrl.deb <<< "$payload")
# arm64_url=$(jq -r .armDownloadUrl.deb <<< "$payload")
curl -L -o /root/linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.12_240902_arm64_01.deb
dpkg -i /root/linuxqq.deb 
apt-get -f install -y
rm /root/linuxqq.deb

# 安装LiteLoader
version=$(curl -Ls "https://api.github.com/repos/LiteLoaderQQNT/LiteLoaderQQNT/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -L -o /tmp/LiteLoaderQQNT.zip https://mirror.ghproxy.com/https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/$version/LiteLoaderQQNT.zip
mkdir -p /opt/QQ/resources/app/LiteLoader
unzip /tmp/LiteLoaderQQNT.zip -d /opt/QQ/resources/app/LiteLoader
sed -i '1s/^/require("\/opt\/QQ\/resources\/app\/LiteLoader");\n/' /opt/QQ/resources/app/app_launcher/index.js
rm /tmp/LiteLoaderQQNT.zip