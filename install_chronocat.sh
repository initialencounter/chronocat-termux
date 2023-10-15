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

echo "正在删除缓存"
apt-get clean
rm -rf /var/lib/apt/lists/*