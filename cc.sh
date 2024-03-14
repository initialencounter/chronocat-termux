# 设置环境变量
export DEBIAN_FRONTEND=noninteractive

# 安装必要的软件包
apt update && apt install -y \
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
    apt autoremove -y && \
    apt clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# 安装Linux QQ
curl -o /root/linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.5_240305_arm64_01.deb && \
dpkg -i /root/linuxqq.deb && apt-get -f install -y && rm /root/linuxqq.deb

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
echo "chmod 777 /tmp &
rm -rf /run/dbus/pid &
rm /tmp/.X1-lock &
mkdir -p /var/run/dbus &
dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address &
Xvfb :1 -screen 0 1080x760x16 &
export DISPLAY=:1
fluxbox & 
x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -rfbauth ~/.vnc/passwd &
nohup /opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6081 --file-only &
x11vnc -storepasswd vncpasswd ~/.vnc/passwd
qq --no-sandbox &" > /root/start.sh

# 安装chronocat  
mkdir -p /opt/QQ/resources/app/LiteLoader/plugins/
curl -L -o /tmp/chronocat-llqqnt-engine-chronocat-api.zip https://github.com/chrononeko/chronocat/releases/download/v0.2.4/chronocat-llqqnt-engine-chronocat-api-v0.2.4.zip && \
curl -L -o /tmp/chronocat-llqqnt-engine-chronocat-event.zip https://github.com/chrononeko/chronocat/releases/download/v0.2.4/chronocat-llqqnt-engine-chronocat-event-v0.2.4.zip && \
curl -L -o /tmp/chronocat-llqqnt-engine-poke.zip https://github.com/chrononeko/chronocat/releases/download/v0.2.4/chronocat-llqqnt-engine-poke-v0.2.4.zip  && \
curl -L -o /tmp/chronocat-llqqnt.zip https://github.com/chrononeko/chronocat/releases/download/v0.2.4/chronocat-llqqnt-v0.2.4.zip
unzip /tmp/chronocat-llqqnt-engine-chronocat-api.zip  -d /opt/QQ/resources/app/LiteLoader/plugins/
unzip /tmp/chronocat-llqqnt-engine-chronocat-event.zip  -d /opt/QQ/resources/app/LiteLoader/plugins/
unzip /tmp/chronocat-llqqnt-engine-poke.zip -d /opt/QQ/resources/app/LiteLoader/plugins/
unzip /tmp/chronocat-llqqnt.zip -d /opt/QQ/resources/app/LiteLoader/plugins/

echo -e "chronocat 安装完成
现在你可以输入命令 \e[32mbash debian-sid-arm64.sh\e[0m 进入容器
再输入命令 \e[32mbash /root/start.sh\e[0m 来启动服务
如果需要以无头模式启动;，请修改/root/start.sh
在 \e[32mqq --no-sandbox\e[0m 末尾添加选项 \e[32m--chrono-mode=headless3\e[0m"