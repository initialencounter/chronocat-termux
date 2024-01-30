#!/bin/bash
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