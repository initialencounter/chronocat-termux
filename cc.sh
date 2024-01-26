# 设置环境变量
export DEBIAN_FRONTEND=noninteractive
export VNC_PASSWD=vncpasswd
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
    libgbm1 \
    libasound2 \
    fonts-wqy-zenhei \
    git \
    gnutls-bin

# 安装novnc
git config --global http.sslVerify false && \
    git config --global http.postBuffer 1048576000 && \
    cd /opt && git clone https://mirror.ghproxy.com/https://github.com/novnc/noVNC.git && \
    cd /opt/noVNC/utils && git clone https://mirror.ghproxy.com/https://github.com/novnc/websockify.git && \
    cp /opt/noVNC/vnc.html /opt/noVNC/index.html     

# 安装Linux QQ
curl -o /root/linuxqq_3.2.5-20979_arm64.deb https://dldir1.qq.com/qqfile/qq/QQNT/c64ca459/linuxqq_3.2.5-20979_arm64.deb && \
    dpkg -i /root/linuxqq_3.2.5-20979_arm64.deb && apt-get -f install -y && rm /root/linuxqq_3.2.5-20979_arm64.deb

# 安装LiteLoader
curl -L -o /tmp/LiteLoaderQQNT.zip https://mirror.ghproxy.com/https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/1.0.2/LiteLoaderQQNT.zip && \
    mkdir -p /opt/QQ/resources/app/LiteLoader && \
    unzip /tmp/LiteLoaderQQNT.zip -d /opt/QQ/resources/app/LiteLoader && \
    sed -i '1s/^/require("\/opt\/QQ\/resources\/app\/LiteLoader");\n/' /opt/QQ/resources/app/app_launcher/index.js && \
    rm /tmp/LiteLoaderQQNT.zip

# 安装chronocat  
mkdir -p /opt/QQ/resources/app/LiteLoader/plugins && \
   unzip chronocat-llqqntv1-v0.0.71.zip -d /opt/QQ/resources/app/LiteLoader/plugins/ && \
   rm /tmp/chronocat-llqqntv1-v0.0.71.zip

# 创建必要的目录
mkdir -p ~/.vnc

# 创建启动脚本
# 配置supervisor
echo "[supervisord]" > /etc/supervisor/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisor/supervisord.conf && \
    echo "[program:x11vnc]" >> /etc/supervisor/supervisord.conf && \
    echo "command=/usr/bin/x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -rfbauth ~/.vnc/passwd" >> /etc/supervisor/supervisord.conf

echo "#!/bin/bash
service dbus start
rm -f /tmp/.X1-lock
export DISPLAY=:1
Xvfb :1 -screen 0 720x512x16 &
fluxbox &
sleep 2
x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -rfbauth ~/.vnc/passwd &
sleep 2
nohup /opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6081 --file-only &
sleep 2
x11vnc -storepasswd $VNC_PASSWD ~/.vnc/passwd
sleep 2
qq --no-sandbox
" > /root/start.sh

echo "现在你可以输入命令 bash /root/start.sh 来启动服务