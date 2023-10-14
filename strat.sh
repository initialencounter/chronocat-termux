export PATH=$PATH:/usr/local/node-v18.18.0-linux-arm64/bin

if [ -f "/home/ie/vncing" ]; then
  echo 'VNC 已启动
输入 qq 启动 qqnt
输入 yarn start 启动 koishi'
else
  echo "请输入密码，默认为 123456
Please enter 123456:"
  sudo mkdir /tmp/.X11-unix	
  sudo chown ie:ie /tmp/.X11-unix
  startvnc
  touch vncing
fi
