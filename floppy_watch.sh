#!/bin/bash
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec >> /home/pi/Documents/myDiskplayer/log.txt 2>&1


play() {
	sudo systemd-mount $1 /media/$2
	#sudo mount $1 /media/floppy
	output=$(cat /media/$2/uri.txt)
	echo playing $output
	python /home/pi/Documents/myDiskplayer/play_music.py -uri $output
	sudo systemd-mount --umount /media/$2
	#sudo umount  $1
}

whoami

echo "---Begin log---" 

date 
echo $1 

dev=$1

searchStr=${dev: -3} 

echo $searchStr
mnt=$(date +%s)

lsblk |grep $searchStr
if [ $? -eq 0 ]; then #device is inserted properly
	play $1 $mnt
else #no device found in lsblk 
	mnt2=$(date +%N)
	sudo mkdir /media/$mnt2
	sudo mount $1 /media/$mnt2 > sudooutput.txt 2>&1
	eCode=$(cat sudooutput.txt)
	echo "eCode = ${eCode}"
	echo $eCode|grep superblock 
	if [ $? -eq 0 ]; then #cant read superblock restarting usb bus
		echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind
		sleep 1
		echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind
		sleep 5
		play $1 $mnt
	else #no disk inserted
		echo empty, pausing 
		python /home/pi/Documents/myDiskplayer/play_music.py -pause
	fi
fi

echo "---End log---"
