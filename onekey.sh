# 安装 debian 容器
bash -c "$(curl -L https://github.com/initialencounter/chronocat-termux/raw/main/debian.sh)"

# 安装脚本
curl -L -o bookworm-arm64/root/cc.sh https://github.com/initialencounter/chronocat-termux/raw/main/cc.sh

# 启动容器并安装
unset LD_PRELOAD
proot --bind=/vendor --bind=/system --bind=/data/data/com.termux/files/usr --bind=/storage --bind=/storage/self/primary:/sdcard --bind=/data/data/com.termux/files/home --bind=/data/data/com.termux/cache --bind=/data/dalvik-cache --bind=bookworm-arm64/tmp:/dev/shm --bind=bookworm-arm64/etc/proc/vmstat:/proc/vmstat --bind=bookworm-arm64/etc/proc/version:/proc/version --bind=bookworm-arm64/etc/proc/uptime:/proc/uptime --bind=bookworm-arm64/etc/proc/stat:/proc/stat --bind=bookworm-arm64/etc/proc/loadavg:/proc/loadavg  --bind=bookworm-arm64/etc/proc/bus/pci/00:/proc/bus/pci/00 --bind=bookworm-arm64/etc/proc/devices:/proc/bus/devices --bind=bookworm-arm64/etc/proc/bus/input/devices:/proc/bus/input/devices --bind=bookworm-arm64/etc/proc/modules:/proc/modules   --bind=/sys --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/data/data/com.termux/files/usr/tmp:/tmp --bind=/data/data/com.termux/files:bookworm-arm64/termux --bind=/dev --root-id --cwd=/root -L --kernel-release=5.17.18-perf --sysvipc --link2symlink --kill-on-exit --rootfs=bookworm-arm64/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /bin/su -l root /root/cc.sh

echo "bash bookworm-arm64.sh" > ~/.bashrc
echo "bash /root/start.sh" >> ~/bookworm-arm64/root/.bashrc
