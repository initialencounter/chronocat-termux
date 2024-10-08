# 创建启动脚本
echo "chmod 777 /tmp &
rm -rf /run/dbus/pid &
rm -rf /tmp/.X1-lock &
mkdir -p /var/run/dbus &
dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address > /dev/null &
Xvfb :1 -screen 0 1080x760x16  > /dev/null &
export DISPLAY=:1
qq --no-sandbox --disable-gpu" > /root/start.sh

# 安装chronocat  
version=v0.2.19
curl -L -o /tmp/chronocat-llqqnt-engine-chronocat-api.zip https://github.com/chrononeko/chronocat/releases/download/$version/chronocat-llqqnt-engine-chronocat-api-$version.zip
curl -L -o /tmp/chronocat-llqqnt-engine-chronocat-event.zip https://github.com/chrononeko/chronocat/releases/download/$version/chronocat-llqqnt-engine-chronocat-event-$version.zip
curl -L -o /tmp/chronocat-llqqnt-engine-media.zip https://github.com/chrononeko/chronocat/releases/download/$version/chronocat-llqqnt-engine-media-$version.zip
curl -L -o /tmp/chronocat-llqqnt-engine-crychiccat.zip https://github.com/chrononeko/chronocat/releases/download/$version/chronocat-llqqnt-engine-crychiccat-$version.zip
curl -L -o /tmp/chronocat-llqqnt.zip https://github.com/chrononeko/chronocat/releases/download/$version/chronocat-llqqnt-$version.zip
unzip /tmp/chronocat-llqqnt-engine-chronocat-api.zip  -d /LiteLoader/plugins/
unzip /tmp/chronocat-llqqnt-engine-chronocat-event.zip  -d /LiteLoader/plugins/
unzip /tmp/chronocat-llqqnt.zip -d /LiteLoader/plugins/
unzip /tmp/chronocat-llqqnt-engine-media.zip -d /LiteLoader/plugins/
unzip /tmp/chronocat-llqqnt-engine-crychiccat.zip -d /LiteLoader/plugins/


echo -e "chronocat 安装完成
现在你可以输入命令 \e[32mbash debian-sid-arm64.sh\e[0m 进入容器
再输入命令 \e[32mbash /root/start.sh\e[0m 来启动服务"