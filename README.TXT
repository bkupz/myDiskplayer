instructions:

*** Project based off of: https://www.dinofizzotti.com/blog/2020-02-05-diskplayer-using-3.5-floppy-disks-to-play-albums-on-spotify/ ***

* Get a usb floppy disk drive

* Install raspotify: https://github.com/dtcooper/raspotify

* Install spotipy:
    * run $ pip install spotipy

* Install this directory/repo on your pi and remember the path!

* Replace all occurances of '/home/pi/Documents/myDiskplayer/' in floppy_watch.sh, checker.sh, add_request.sh and play_music.py with /the_path_I_told_you_to_remember/ OR put keep this stuff in the path above

* Make sure the usb floppy disk drive is plugged in

* Run $ lsusb 
    * My output:
        Bus 001 Device 004: ID 0424:0fdc Standard Microsystems Corp. Floppy
    * You should note the two four hex digits seperated by a colon, those are your idVendor and idProduct numbers used in the next step:

* Create a rule at /etc/udev/rules.d/100-floppy-change.rules
    * Put the following in your rule (mine looked like this):
        ACTION=="change", ATTRS{idVendor}=="0424", ATTRS{idProduct}=="0fdc", ENV{DISK_MEDIA_CHANGE}=="1", RUN+="/the_path_I_told_you_to_remember/add_request.sh $env{DEVNAME}"

* Run $ crontab -e

* Add the follwing line in your crontab:
    * @reboot /the_path_I_told_you_to_remember/checker.sh

* Replace the following information in play_music.py with info from your app on spotify (you need to create one. Google it or start here: https://developer.spotify.com/dashboard/):
    username = ""
    client_id = ""
    client_secret = ""
    redirect_uri = ""

* Reboot    

NOTE: You will likely have to cast your music to the raspotify (using a spotify app) before you can use the play_music.py which; plays music, pauses music and searches for active devices  

* For the next step make sure you are connected to the pi via vnc or a screen your browser is going to be opened and you are going to have to log into spotify 

* NOTE: All output will be logged to log.txt that includes all out put from play_music.py

* Run $ python /the_path_I_told_you_to_remember/play_music.py -devices
    * Look for output in log.txt
    * Look for the raspotify entry and put the id in play_music.py device id string:
        piDeviceID = "here"
    * Alternativly, you can cast to other spotify connect devices that show up in this list

* You can test streaming to your chosen device by running:
    * Remember you can only play albums and playlists like this
    python play_music.py -uri spotify:album:06814vxpRbL5CPMk1CTvOk

* Creating floppys to work with this project:
    * Mount the floppy 
    * Create a file called uri.txt in the base directory and paste a uri from spotify 
        * It has to be album or playlist uri
        * Uri's can be found by clicking the ... on the spotify desktop app and by going to Share > Copy Spotify URI

* Plug a floppy with a uri into the drive and it should start playing on your designated device 

* Email me at kupczyk.brandon@gmail.com if you have any issues  

*** how it and why it works ***

* When you plug in the floppy disk the udev rule calls the add_request.sh file which writes the path to the floppy disk to the requests file.

* The checker.sh script checks for anything in the requests file and if it finds something it will call floppy_watch.sh.

* Sometimes these crappy usb floppy disk drives miss-read the disk. The only way I found to try to read the disk again without manually ejecting the disk is to turn the usb hub on and off so thats what this script does. It tries twice and if successful it calls play_music.py -play <uri from floppy disk>