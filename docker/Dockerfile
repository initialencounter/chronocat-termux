# 使用基于Ubuntu 22.04的基础映像
FROM ubuntu:22.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV VNC_PASSWD=vncpasswd

# 安装必要的软件包
RUN apt-get update && apt-get install -y \
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
    gnutls-bin \    
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装novnc
RUN git config --global http.sslVerify false && git config --global http.postBuffer 1048576000
RUN cd /opt && git clone https://mirror.ghproxy.com/https://github.com/novnc/noVNC.git
RUN cd opt/noVNC/utils && git clone https://mirror.ghproxy.com/https://github.com/novnc/websockify.git
RUN cp /opt/noVNC/vnc.html /opt/noVNC/index.html     

# 安装Linux QQ
RUN curl -o /root/linuxqq_3.2.5-20979_amd64.deb https://dldir1.qq.com/qqfile/qq/QQNT/c64ca459/linuxqq_3.2.5-20979_amd64.deb
RUN dpkg -i /root/linuxqq_3.2.5-20979_amd64.deb && apt-get -f install -y && rm /root/linuxqq_3.2.5-20979_amd64.deb

# 安装LiteLoader
RUN curl -L -o /tmp/LiteLoaderQQNT.zip https://mirror.ghproxy.com/https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/1.0.2/LiteLoaderQQNT.zip \
    && unzip /tmp/LiteLoaderQQNT.zip -d /opt/QQ/resources/app/ \
    && rm /tmp/LiteLoaderQQNT.zip
# 修改/opt/QQ/resources/app/package.json文件
RUN sed -i 's/"main": ".\/app_launcher\/index.js"/"main": ".\/LiteLoader"/' /opt/QQ/resources/app/package.json

# 安装chronocat  
COPY chronocat-llqqntv1-v0.0.71.zip /tmp/chronocat-llqqntv1-v0.0.71.zip
RUN mkdir -p /root/LiteLoaderQQNT/plugins \
  && unzip /tmp/chronocat-llqqntv1-v0.0.71.zip -d /root/LiteLoaderQQNT/plugins/ \
  && rm /tmp/chronocat-llqqntv1-v0.0.71.zip

# 创建必要的目录
RUN mkdir -p ~/.vnc

# 创建启动脚本
COPY start.sh /root/start.sh
RUN sed -i "s/VNC_PASSWD/$VNC_PASSWD/" /root/start.sh \
  && chmod +x ~/start.sh

# 配置supervisor
RUN echo "[supervisord]" > /etc/supervisor/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/supervisord.conf
RUN echo "[program:x11vnc]" >> /etc/supervisor/supervisord.conf
RUN echo "command=/usr/bin/x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -rfbauth ~/.vnc/passwd" >> /etc/supervisor/supervisord.conf

# 设置容器启动时运行的命令
CMD ["/bin/bash", "-c", "/root/start.sh"]