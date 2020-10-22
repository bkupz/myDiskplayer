import sys; sys.path = ['/home/pi/.local/lib/python2.7/site-packages'] + sys.path
import spotipy
import spotipy.util as util
from spotipy.oauth2 import SpotifyOAuth
from pprint import pprint

sys.stdout = open("/home/pi/Documents/myDiskplayer/log.txt", "a")
sys.stderr = open("/home/pi/Documents/myDiskplayer/log.txt", "a")
print("log test")

def usage():
    print("Usage: \"python playMusic.py -uri https://spotify.com/uri/example\"")
    print("or")
    print("Usage: \"python playMusic.py -pause")
    print("or")
    print("Usage: \"python playMusic.py -devices")
    exit(-1)

readPlaybackScope = 'user-read-playback-state'
streamScope = 'streaming'

username = ""
client_id = ""
client_secret = ""
redirect_uri = ""
piDeviceID = ""

deviceID = piDeviceID
scope = "user-read-playback-state,user-modify-playback-state"

use = False

if len(sys.argv) < 2:
    usage()


sp = spotipy.Spotify(client_credentials_manager=SpotifyOAuth(client_id=client_id,client_secret=client_secret,redirect_uri=redirect_uri,scope=scope,username=username))

if len(sys.argv) == 3 and sys.argv[1] == "-uri":
    try:
        sp.pause_playback()
    except:
        print("No device playing music")
    sp.start_playback(deviceID, sys.argv[2])
    exit(0)

if len(sys.argv) == 2 and sys.argv[1] == "-pause":
    sp.pause_playback(deviceID)
    exit(0)

if len(sys.argv) == 2 and sys.argv[1] == "-devices":
    devs = sp.devices()
    pprint(devs)
    exit(0)

usage()


