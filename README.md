# 在手机上安装超时空猫猫

本项目提供了在安卓手机上安装 [chronocat](https://chronocat.vercel.app/) 的方法
使用 [ZeroTermux](https://github.com/hanxinhao000/ZeroTermux) + debian-sid + xfce4 + linuxqq 制作

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

#### 2.1.1 下载恢复包
前往 [百度网盘](https://pan.baidu.com/s/1G1_-qzpL3b1bDoqDcWDnlg?pwd=i4bt) 或 [Github releases](https://github.com/initialencounter/chronocat-termux/releases) 下载 ZeroTermux 恢复包, 并将恢复包放在 手机的 `内部存储/xinhao/data/` 目录
   ![location](./screenshot/location.jpg)

- 注意事项： 
    - 恢复包要放在 `内部存储/xinhao/data/`目录或者 `/sdcard/xinhao/data`目录，否则在恢复容器的时候无法找到恢复包

#### 2.1.2 恢复容器
- 打开ZeroTermux
- 恢复
    进入ZeroTermux 点击音量上键 呼出菜单栏 点击菜单栏的 `备份/恢复` 选择下载的恢复包
    ![restore](./screenshot/refresh.png)
    输入一个容器名字点击恢复 这个过程需要等待几分钟
    ![refreshdone](./screenshot/refreshDone.jpg)
- 切换容器
   ![switch](./screenshot/switch.png)
    再次点击音量上键， 呼出菜单栏，点击菜单栏的 `容器切换` 选择刚才创建的容器 询问你是否需要重启时， 选择立即重启，接下你将进入启动界面

- 注意事项：
    - 如果音量上键无法呼出菜单，说明你的ZeroTermux版本比较旧，那么可以使用右滑左侧的屏幕边缘来呼出菜单栏

### 2.2 使用命令安装（不推荐）
若你使用的是 `2.1 使用恢复包安装`，请跳过该步骤
#### 2.2.1 安装linux容器
   输入命令
   ```shell
   bash -c "$(curl -L https://gitee.com/initencunter/chronocat-termux/raw/main/debian.sh)"
   ```
#### 2.2.2 安装图形界面 
   ```shell
   # 进入容器
   bash debian-sid-arm64.sh
   # 安装 tmoe
   apt install -y curl ; bash -c "$(curl -L gitee.com/mo2/linux/raw/2/2)"
   # 一路回车，选择tools
   # 再选择安装 xfce 图形界面 以及 tigervnc
   ```
### 2.2.3 安装 qq
   ```shell
   curl -o /root/linuxqq_3.2.5-20979_amd64.deb https://dldir1.qq.com/qqfile/qq/QQNT/c64ca459/linuxqq_3.2.5-20979_amd64.deb && \
   dpkg -i /root/linuxqq_3.2.5-20979_amd64.deb && apt-get -f install -y && rm /root/linuxqq_3.2.5-20979_amd64.deb
   ```
### 2.2.4 [安装liteloader](https://liteloaderqqnt.github.io/guide/install.html)
   ```shell
   curl -L -o /tmp/LiteLoaderQQNT.zip https://mirror.ghproxy.com/https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/1.0.2/LiteLoaderQQNT.zip && \
   mkdir -p /opt/QQ/resources/app/LiteLoader && \
   unzip /tmp/LiteLoaderQQNT.zip -d /opt/QQ/resources/app/LiteLoader && \
   sed -i '1s/^/require("\/opt\/QQ\/resources\/app\/LiteLoader");\n/' /opt/QQ/resources/app/app_launcher/index.js && \
   rm /tmp/LiteLoaderQQNT.zip
   ```
### 2.2.4[安装chronocat]
   ```shell
   # 在此之前你需要先下载 chronocat-llqqntv1-v0.0.71.zip
   mkdir -p /opt/QQ/resources/app/LiteLoader/plugins && \
   unzip chronocat-llqqntv1-v0.0.71.zip -d /opt/QQ/resources/app/LiteLoader/plugins/ && \
   rm /tmp/chronocat-llqqntv1-v0.0.71.zip
   ```

### 启动脚本
   ```shell
   #!/bin/bashs
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
   ```
### 2.3 使用一键脚本
   ```shell
   bash -c "$(curl -L https://gitee.com/initencunter/chronocat-termux/raw/main/onekey.sh)"
   ```
### 3. 启动 VNC
>如果你使用的是恢复包，VNC将会在进入终端时自启
如果你的 chronocat 是用命令安装的，那么你需要执行启动命令
```shell
bash /root/start.sh
```

### 4. 登录vnc
使用VNC软件登陆服务器IP:5900 默认密码是vncpasswd
![loginVNC](./screenshot/loginVNC.png)

### 5. 登录qqnt
![startqq](./screenshot/startServer.png)
在终端中输入qq, 回车
一段时间后桌面会弹出二维码，拿出手机来扫码即可
- 注意事项： 
>登录后qqnt会提醒你更新，不要更新
登录成功后可以前往 127.0.0.1:5500 查看是否成功接入 chronocat
若出现以下画面, 恭喜你接入了 chronocat
[![successed](./screenshot/successed.png)](https://chronocat.vercel.app/connect)

### 7. 修改chronocat配置
修改容器目录 /root/.chronocat/config/chronocat.yml，修改后重启 termux