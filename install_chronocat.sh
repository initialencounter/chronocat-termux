# 检测运行环境
if uname -a | grep -q "Android"; then
    echo "当前会话不处于proot，请在proot容器内运行该脚本"
    echo "请联系作者"
    exit 1
else
    echo "您的会话正处于 proot 容器内"
fi

arch=$(uname -m)
if [[ $arch == "aarch64" ]]; then
    echo "当前系统是ARMv8架构"
else
    echo "该脚本只适用于AMRv8架构"
    exit 1
fi

# 安装依赖
echo "正在安装依赖"

apt-get update && apt-get install -y openbox curl unzip x11vnc xvfb fluxbox supervisor libnotify4 libnss3 xdg-utils libsecret-1-0 libgbm1 libasound2 fonts-wqy-zenhei git gnutls-bin screen

echo "正在删除缓存"
apt-get clean
rm -rf /var/lib/apt/lists/*

# 安装Linux QQ
curl -o /root/linuxqq_3.1.2-13107_arm64.deb https://dldir1.qq.com/qqfile/qq/QQNT/ad5b5393/linuxqq_3.1.2-13107_arm64.deb
dpkg -i /root/linuxqq_3.1.2-13107_arm64.deb && apt-get -f install -y && rm /root/linuxqq_3.1.2-13107_arm64.deb

# 安装LiteLoader
curl -L -o /tmp/LiteLoaderQQNT.zip https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/0.5.3/LiteLoaderQQNT.zip

unzip /tmp/LiteLoaderQQNT.zip -d /opt/QQ/resources/app/
rm /tmp/LiteLoaderQQNT.zip

# 修改/opt/QQ/resources/app/package.json文件
sed -i 's/"main": ".\/app_launcher\/index.js"/"main": ".\/LiteLoader"/' /opt/QQ/resources/app/package.json

# 安装chronocat  
curl -L -o /tmp/chronocat-llqqnt.zip https://ghproxy.com/https://github.com/chrononeko/chronocat/releases/download/v0.0.48/chronocat-llqqnt-v0.0.48.zip
mkdir -p /root/LiteLoaderQQNT/plugins
unzip /tmp/chronocat-llqqnt.zip -d /root/LiteLoaderQQNT/plugins/
rm /tmp/chronocat-llqqnt.zip



# 创建必要的目录
mkdir -p ~/.vnc

# 创建启动脚本
echo "#!/bin/bash" > ~/start.sh
echo "rm /tmp/.X1-lock" >> ~/start.sh
echo "Xvfb :1 -screen 0 1280x1024x16 &" >> ~/start.sh
echo "export DISPLAY=:1" >> ~/start.sh
echo "fluxbox &" >> ~/start.sh
echo "x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -rfbauth ~/.vnc/passwd &" >> ~/start.sh
echo "nohup /opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6081 --file-only &" >> ~/start.sh
echo "x11vnc -storepasswd \$VNC_PASSWD ~/.vnc/passwd" >> ~/start.sh
echo "su -c 'qq' root" >> ~/start.sh
chmod +x ~/start.sh

# 配置supervisor
echo "[supervisord]" > /etc/supervisor/supervisord.conf
echo "nodaemon=true" >> /etc/supervisor/supervisord.conf
echo "[program:x11vnc]" >> /etc/supervisor/supervisord.conf
echo "command=/usr/bin/x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -rfbauth ~/.vnc/passwd" >> /etc/supervisor/supervisord.conf

# 启动时运行的命令
chmod 777 /run/screen
screen -wipe

if screen -list | grep -q "ccr"; then
    screen -S cc -X quit
else
    # 启动 qsinServer
    echo "正在启动 cc"
fi
screen -dmS cc
screen -S cc -p 0 -X stuff "bash /root/start.sh$(printf \\r)"
echo "chronocat,已启动，输入screen -r cc查看输出，ctrl+a+d挂起"

