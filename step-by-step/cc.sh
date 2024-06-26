# 配置supervisor
echo "[supervisord]" > /etc/supervisord.conf
echo "nodaemon=true" >> /etc/supervisord.conf
echo "[program:qq]" >> /etc/supervisord.conf
echo "command=qq --no-sandbox" >> /etc/supervisord.conf
echo 'environment=DISPLAY=":1"' >> /etc/supervisord.conf

# 创建启动脚本
echo "chmod 777 /tmp &
rm -rf /run/dbus/pid &
rm -rf /tmp/.X1-lock &
mkdir -p /var/run/dbus &
echo "登录方法: 浏览器访问 http://localhost:6099/api/panel/getQQLoginQRcode"
dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address > /dev/null &
Xvfb :1 -screen 0 1080x760x16  > /dev/null &
export DISPLAY=:1
exec supervisord &" > /root/start.sh

# 安装LLWebUiApi
mkdir -p /opt/QQ/resources/app/LiteLoader/plugins/LLWebUiApi
curl -L -o /tmp/LLWebUiApi.zip https://mirror.ghproxy.com/https://github.com/LLOneBot/LLWebUiApi/releases/download/v0.0.31/LLWebUiApi.zip
mkdir -p /opt/QQ/resources/app/LiteLoader/data/LLWebUiApi
unzip /tmp/LLWebUiApi.zip -d /opt/QQ/resources/app/LiteLoader/plugins/LLWebUiApi
echo '{"Server":{"Port":6099},"AutoLogin":true,"BootMode":3,"Debug":false}' > /opt/QQ/resources/app/LiteLoader/data/LLWebUiApi/config.json
rm /tmp/LLWebUiApi.zip

# 安装chronocat  
version=$(curl -Ls "https://api.github.com/repos/chrononeko/chronocat/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
mkdir -p /opt/QQ/resources/app/LiteLoader/plugins/
curl -L -o /tmp/chronocat-llqqnt-engine-chronocat-api.zip https://github.com/chrononeko/chronocat/releases/download/$version/chronocat-llqqnt-engine-chronocat-api-$version.zip
curl -L -o /tmp/chronocat-llqqnt-engine-chronocat-event.zip https://github.com/chrononeko/chronocat/releases/download/$version/chronocat-llqqnt-engine-chronocat-event-$version.zip
curl -L -o /tmp/chronocat-llqqnt.zip https://github.com/chrononeko/chronocat/releases/download/$version/chronocat-llqqnt-$version.zip
unzip /tmp/chronocat-llqqnt-engine-chronocat-api.zip  -d /opt/QQ/resources/app/LiteLoader/plugins/
unzip /tmp/chronocat-llqqnt-engine-chronocat-event.zip  -d /opt/QQ/resources/app/LiteLoader/plugins/
unzip /tmp/chronocat-llqqnt.zip -d /opt/QQ/resources/app/LiteLoader/plugins/

echo -e "chronocat 安装完成
现在你可以输入命令 \e[32mbash debian-sid-arm64.sh\e[0m 进入容器
再输入命令 \e[32mbash /root/start.sh\e[0m 来启动服务"