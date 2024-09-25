# 设置环境变量
export DEBIAN_FRONTEND=noninteractive

# 安装必要的软件包
apt update && apt install -y \
    openbox \
    curl \
    unzip \
    xvfb \
    libnotify4 \
    libnss3 \
    libxss1 \
    xdg-utils \
    libsecret-1-0 \
    libasound2 \
    fonts-wqy-zenhei \
    jq \
    gnutls-bin && \
    apt autoremove -y && \
    apt clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

################################################################################################################################

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

################################################################################################################################

# 创建启动脚本
echo "chmod 777 /tmp &
rm -rf /run/dbus/pid &
rm -rf /tmp/.X1-lock &
mkdir -p /var/run/dbus &
echo "登录方法: 浏览器访问 http://localhost:6099/api/panel/getQQLoginQRcode"
dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address > /dev/null &
Xvfb :1 -screen 0 1080x760x16  > /dev/null &
export DISPLAY=:1
qq --no-sandbox --disable-gpu" > /root/start.sh

# 安装LLWebUiApi
mkdir -p /opt/QQ/resources/app/LiteLoader/plugins/LLWebUiApi
curl -L -o /tmp/LLWebUiApi.zip https://mirror.ghproxy.com/https://github.com/initialencounter/chronocat-termux/releases/download/v0.0.0/LLWebUiApi.zip
mkdir -p /opt/QQ/resources/app/LiteLoader/data/LLWebUiApi
unzip /tmp/LLWebUiApi.zip -d /opt/QQ/resources/app/LiteLoader/plugins/LLWebUiApi
echo '{"Server":{"Port":6099},"AutoLogin":true,"BootMode":3,"Debug":false}' > /opt/QQ/resources/app/LiteLoader/data/LLWebUiApi/config.json
rm /tmp/LLWebUiApi.zip

# 安装chronocat  
version=$(curl -Ls "https://api.github.com/repos/chrononeko/chronocat/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -L -o /tmp/chronocat.js.ti-$version.bin https://github.com/chrononeko/chronocat/releases/download/$version/chronocat.js.ti-$version.bin
dd bs=1024 skip=1 if=/tmp/chronocat.js.ti-$version.bin of=/opt/QQ/resources/app/app_launcher/chronocat.js
echo "require('./chronocat.js')" >> /opt/QQ/resources/app/app_launcher/launcher.js
echo -e "chronocat 安装完成
现在你可以输入命令 \e[32mbash debian-sid-arm64.sh\e[0m 进入容器
再输入命令 \e[32mbash /root/start.sh\e[0m 来启动服务"