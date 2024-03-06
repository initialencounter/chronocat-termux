# 在手机上安装超时空猫猫

本项目提供了在安卓手机上安装 [chronocat](https://chronocat.vercel.app/) 的方法
使用 [ZeroTermux](https://github.com/hanxinhao000/ZeroTermux) + debian-sid + linuxqq 制作

- 基于 Linux QQ
- 运行内存大于 600M
- 恢复包大小 795 MB（压缩后）
- 支持持久化 QQ 登录状态和数据

# 目录：
- 1. 安装 ZeroTermux 和 VncView
- 2. 安装 chronocat
   * 2.1 方法1. 使用恢复包安装（推荐）
   * 2.2 方法2. 使用命令安装
- 3. 启动 VNC
- 4. 登录 VNC
- 5. 登录 Linux QQ
- 6. 启动 [Koishi](https://koishi.chat)
- 7. 修改 chronocat 配置

## 1. 安装 ZeroTermux 和 VncView
前往[hanxinhao000/ZeroTermux](https://github.com/hanxinhao000/ZeroTermux/releases)下载 ZeroTermux 安装包并安装
安装一个vnc客户端，推荐 [RealVNC](https://play.google.com/store/apps/details?id=com.realvnc.viewer.android)

- 注意事项： 
   直接从 GitHub 下载 ZeroTermux 速度可能会很慢，建议使用 [ghproxy.com](https://ghproxy.com) 代理
    
## 2. 安装 chronocat
   - 方法1. 使用恢复包（推荐）
      >优点：操作简单，易上手
缺点：无
   - 方法2. 使用命令安装
      >优点：可以学习到很多知识
缺点：耗时，需要良好的网络环境，再次启动比较麻烦，需要手动启动 VNC

### 2.1 使用恢复包安装（推荐）

<details>
  <summary>点击展开内容！</summary>

#### 2.1.1 下载恢复包
前往 [百度网盘](https://pan.baidu.com/s/1G1_-qzpL3b1bDoqDcWDnlg?pwd=i4bt) 或 [Github releases](https://github.com/initialencounter/chronocat-termux/releases) 下载 ZeroTermux 恢复包, 并将恢复包放在 手机的 `内部存储/xinhao/data/` 目录

- 注意事项： 
    - 恢复包要放在 `内部存储/xinhao/data/`目录或者 `/sdcard/xinhao/data`目录，否则在恢复容器的时候无法找到恢复包

#### 2.1.2 恢复容器
- 打开ZeroTermux
- 恢复
    进入ZeroTermux 点击音量上键 呼出菜单栏 点击菜单栏的 `备份/恢复` 选择下载的恢复包
    输入一个容器名字点击恢复 这个过程需要等待几分钟
- 切换容器
    再次点击音量上键， 呼出菜单栏，点击菜单栏的 `容器切换` 选择刚才创建的容器 询问你是否需要重启时， 选择立即重启，接下你将进入启动界面

- 注意事项：
    - 如果音量上键无法呼出菜单，说明你的ZeroTermux版本比较旧，那么可以使用右滑左侧的屏幕边缘来呼出菜单栏

</details>

### 2.2 使用命令安装（不推荐）
<details>
  <summary>点击展开内容！</summary>

#### 2.2.1 安装linux容器
   输入命令
   ```shell
   bash -c "$(curl -L https://github.com/LLOneBot/llonebot-termux/raw/main/debian.sh)"
   ```
#### 2.2.2 安装图形界面 
   ```shell
   # 进入容器
   bash bookworm-arm64.sh
   # 安装图形界面
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
    gnutls-bin && \    
    apt autoremove -y && \
    apt clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*
   ```
#### 2.2.3 安装 qq
   ```shell
   curl -o /root/linuxqq_3.2.5-21453_arm64.deb https://dldir1.qq.com/qqfile/qq/QQNT/852276c1/linuxqq_3.2.5-21453_arm64.deb && \
   dpkg -i /root/linuxqq_3.2.5-21453_arm64.deb && apt-get -f install -y && rm /root/linuxqq_3.2.5-21453_arm64.deb
   ```
#### 2.2.4 [安装liteloader](https://liteloaderqqnt.github.io/guide/install.html)
   ```shell
   curl -L -o /tmp/LiteLoaderQQNT.zip https://mirror.ghproxy.com/https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/1.0.3/LiteLoaderQQNT.zip && \
   mkdir -p /opt/QQ/resources/app/LiteLoader && \
   unzip /tmp/LiteLoaderQQNT.zip -d /opt/QQ/resources/app/LiteLoader && \
   sed -i '1s/^/require("\/opt\/QQ\/resources\/app\/LiteLoader");\n/' /opt/QQ/resources/app/app_launcher/index.js && \
   rm /tmp/LiteLoaderQQNT.zip
   ```
### 2.2.4[安装chronocat]
   ```shell
   # 在此之前你需要先下载 chronocat
   mkdir -p /opt/QQ/resources/app/LiteLoader/plugins && \
   unzip chronocat.zip -d /opt/QQ/resources/app/LiteLoader/plugins/
   ```
#### 启动脚本
   ```shell
   #!/bin/bash
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
   ```
</details>

### 2.3 使用一键脚本
   ```shell
   bash -c "$(curl -L https://github.com/initialencounter/chronocat-termux/raw/main/onekey.sh)"
   ```
### 3. 启动 VNC
>如果你使用的是恢复包，VNC将会在进入终端时自启
如果你的 chronocat 是用命令安装的，那么你需要执行启动命令
```shell
bash /root/start.sh
```

### 4. 登录vnc
使用VNC软件登陆服务器IP:5900 默认密码是vncpasswd

### 5. 登录qqnt
在终端中输入qq, 回车
一段时间后桌面会弹出二维码，拿出手机来扫码即可, 第一次登录可能会闪退，重新执行命令 `qq --no-sandbox` 即可， 如需以无头模式启动则执行命令 `qq --no-sandbox --chrono-mode=headless3`
- 注意事项： 
>登录后qqnt会提醒你更新，不要更新
登录成功后可以前往 127.0.0.1:5500 查看是否成功接入 chronocat
若出现以下画面, 恭喜你接入了 chronocat

### 7. 修改chronocat配置
修改容器目录 /root/.chronocat/config/chronocat.yml，修改后重启 termux