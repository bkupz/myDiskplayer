#!/bin/bash
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec >> /home/pi/Documents/myDiskplayer/log.txt 2>&1

echo $1 >> /home/pi/Documents/myDiskplayer/requests
