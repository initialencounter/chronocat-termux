cd ~
termux-setup-storage
sleep 1
directory="/data/data/com.termux"
name="$(date +%Y_%m_%d_%H_%M_%S).tar.gz"
cd ${directory}/files && tar -zcvf ${directory}/files/home/storage/shared/xinhao/data/${name} home usr
echo "备份完成，输出目录：内部存储/xinhao/data/${name}"
