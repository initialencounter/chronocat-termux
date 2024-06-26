# 安装Linux QQ
curl -o /root/linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.8_240520_arm64_01.deb
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