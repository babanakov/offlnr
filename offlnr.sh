#!/usr/bin/env python

import dropbox
import requests
import json
import sys
import os
from dropbox.files import WriteMode
import RPi.GPIO as GPIO
import time
import requests

import requests.packages.urllib3
requests.packages.urllib3.disable_warnings()

GPIO.setwarnings(False)

GPIO.setmode(GPIO.BCM)
GPIO.setup(27, GPIO.OUT)
GPIO.setup(22, GPIO.OUT)
GPIO.setup(16, GPIO.OUT)
GPIO.setup(12, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)

TOKEN = "-y8PneM3trAAAAAAAAAAIyT5quv2Oe-l85hak81YiENRTciDam5BE969QaGU3nfK"
url = "https://api.dropboxapi.com/2/files/list_folder"
dbx = dropbox.Dropbox(TOKEN)
h_token = "Bearer " + TOKEN
localpath = "/media/FLASH"
folder = "/SYNC"

headers = {
    "Authorization": h_token,
    "Content-Type": "application/json"
}

data = {
    "path": folder,
}
r = requests.post(url, headers=headers, data=json.dumps(data))

j_data = json.loads(r.text)


def download():
	n = j_data['entries']
	y=len(n)
	print y, "files to get"
	GPIO.output(22, True)
        time.sleep(0.2)
	GPIO.output(22, False)
	time.sleep(0.2)
	GPIO.output(22, True)
        time.sleep(0.2)
        GPIO.output(22, False)

	print "-------------------------------------------"
	for x in xrange(y):
		j_value = j_data['entries'][x]['path_lower']
		j_file = j_data['entries'][x]['name']
		GPIO.output(27, False)
		time.sleep(0.1)
		print x+1, "Getting", j_file

		local = localpath+folder+'/'+j_file
		GPIO.output(27, True)
		dbx.files_download_to_file(local, j_value)

                GPIO.output(27, False)
                time.sleep(0.1)
		GPIO.output(27, True)
	print "-------------------------------------------"
	print localpath+folder+'/'
	dirr = os.listdir(localpath+folder)
	print dirr
	print "-------------------------------------------"


if __name__ == '__main__':

	GPIO.output(22, False)
        download()

GPIO.output(27, False)
time.sleep(0.6)
GPIO.output(27, True)
time.sleep(0.6)
GPIO.output(27, False)
time.sleep(0.2)
GPIO.output(22, True)
time.sleep(0.2)
GPIO.output(22, False)
GPIO.output(16, True)
time.sleep(0.5)
GPIO.output(16, False)

print "Done."
