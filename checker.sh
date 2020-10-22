#!/bin/bash
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec >> /home/pi/Documents/myDiskplayer/log.txt 2>&1

i=1

while [ $i -gt 0 ]
do
	
	_file="/home/pi/Documents/myDiskplayer/requests"
	[ ! -f "$_file" ] && { echo "Error: $0 file not found."; exit 2; }
 
	if [ -s "$_file" ] 
	then
		echo "$_file has some data."
		dev=$(cat  $_file)
		/home/pi/Documents/myDiskplayer/floppy_watch.sh $dev
  		> /home/pi/Documents/myDiskplayer/requests # empties the requests file
	#else
		#echo "$_file is empty."
	fi
	sleep 1
done
