# 设置环境变量
export DEBIAN_FRONTEND=noninteractive

# 安装必要的软件包
apt-get update && apt-get install -y \
    openbox \
    curl \
    unzip \
    x11vnc \
    xvfb \
    fluxbox \
    supervisor \
    libnotify4 \
    libnss3 \
    xdg-utils \
    libsecret-1-0 \
    libasound2 \
    fonts-wqy-zenhei \
    git \
    gnutls-bin && \    
    apt purge -y wget && \
    apt autoremove -y && \
    apt clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# 安装Linux QQ
curl -o /root/linuxqq_3.2.5-21453_arm64.deb https://dldir1.qq.com/qqfile/qq/QQNT/c64ca459/linuxqq_3.2.5-21453_arm64.deb
dpkg -i /root/linuxqq_3.2.5-21453_arm64.deb
apt-get -f install -y && rm /root/linuxqq_3.2.5-21453_arm64.deb

# 安装LiteLoader
curl -L -o /tmp/LiteLoaderQQNT.zip https://mirror.ghproxy.com/https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/1.0.3/LiteLoaderQQNT.zip
    mkdir -p /opt/QQ/resources/app/LiteLoader
    unzip /tmp/LiteLoaderQQNT.zip -d /opt/QQ/resources/app/LiteLoader
    sed -i '1s/^/require("\/opt\/QQ\/resources\/app\/LiteLoader");\n/' /opt/QQ/resources/app/app_launcher/index.js
    rm /tmp/LiteLoaderQQNT.zip


# 创建必要的目录
mkdir -p ~/.vnc

# 配置supervisor
echo "[supervisord]" > /etc/supervisor/supervisord.conf
echo "nodaemon=true" >> /etc/supervisor/supervisord.conf
echo "[program:x11vnc]" >> /etc/supervisor/supervisord.conf
echo "command=/usr/bin/x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -rfbauth ~/.vnc/passwd" >> /etc/supervisor/supervisord.conf

# 创建启动脚本
echo "#!/bin/bash
service dbus start
rm -f /tmp/.X1-lock
export DISPLAY=:1
Xvfb :1 -screen 0 720x512x16 &
fluxbox &
sleep 2
x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -rfbauth ~/.vnc/passwd &
sleep 2
x11vnc -storepasswd vncpasswd ~/.vnc/passwd
sleep 2
qq --no-sandbox &
bash
" > /root/start.sh

# 安装chronocat  
if [ ! -f "/root/chronocat.zip" ]; then
    echo "mkdir -p /opt/QQ/resources/app/LiteLoader/plugins
    unzip /root/chronocat.zip -d /opt/QQ/resources/app/LiteLoader/plugins/" > /root/next.sh
    echo -e "\e[32m/root/chronocat.zip\e[0m 文件不存在，请下载后执行 \e[32mnext.sh\e[0m"
    exit;
else
    mkdir -p /opt/QQ/resources/app/LiteLoader/plugins
    unzip /root/chronocat.zip -d /opt/QQ/resources/app/LiteLoader/plugins/
    echo "为了避免此前的事件再次发生，请勿在任何公众平台分享或宣传 Chronocat。"
    echo -e "chronocat 安装完成
现在你可以输入命令 \e[32mbash debian-sid-arm64.sh\e[0m 进入容器
再输入命令 \e[32mbash /root/start.sh\e[0m 来启动服务
如果需要以无头模式启动;，请修改/root/start.sh
在 \e[32mqq --no-sandbox\e[0m 末尾添加选项 \e[32m--chrono-mode=headless3\e[0m"
fi