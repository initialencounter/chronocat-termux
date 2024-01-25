#!/bin/bash
rm /tmp/.X1-lock
Xvfb :1 -screen 0 1280x1024x16 &
export DISPLAY=:1
fluxbox &
x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -rfbauth ~/.vnc/passwd &
nohup /opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6081 --file-only &
x11vnc -storepasswd VNC_PASSWD ~/.vnc/passwd
su -c 'qq' root
chmod +x ~/start.sh