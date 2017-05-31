import RPi.GPIO as GPIO
import time
import subprocess, os
import signal
import requests
import requests.packages.urllib3

requests.packages.urllib3.disable_warnings()

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(13, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)
GPIO.setup(12, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)
GPIO.setup(27, GPIO.OUT)
GPIO.setup(22, GPIO.OUT)
GPIO.setup(16, GPIO.OUT)

GPIO.output(27, True)
time.sleep(0.5)
GPIO.output(27, False)

try:
	run = 0
	while True:
		if GPIO.input(13)==0 and run == 0:
         		print "  Ready "
			GPIO.output(27, True)
			um=subprocess.Popen( "/home/pi/umount.sh",shell=True,preexec_fn=os.setsid)			
			time.sleep(1)
			os.killpg(um.pid, signal.SIGTERM)
			GPIO.output(22, True)
			while GPIO.input(13)==0:                        
				time.sleep(0.3)
			
		if GPIO.input(13)==1 and run == 0:
			GPIO.output(16, False)
			GPIO.output(22, False)
			GPIO.output(27, False)
         		GPIO.output(22, True)
			time.sleep(0.2)
			GPIO.output(22, False)
			print "  Starting"
         		m=subprocess.Popen( "/home/pi/mount.sh",shell=True,preexec_fn=os.setsid)
			time.sleep(1)
			os.killpg(m.pid, signal.SIGTERM)
			p=subprocess.Popen( "/home/pi/offlnr.sh",shell=True,preexec_fn=os.setsid)
         		run = 1	
			while GPIO.input(13) == 1:
             			time.sleep(1)
      		if GPIO.input(12)==1 and run ==1:
                        os.killpg(p.pid, signal.SIGTERM)
                        run = 0

#		if GPIO.input(13)==1 and run == 1:
#         		print "  Stopped " 
#         		run = 0
#         		os.killpg(p.pid, signal.SIGTERM)         		
#			um=subprocess.Popen( "/home/pi/umount.sh",shell=True,preexec_fn=os.setsid)
#                        time.sleep(1)
#                        os.killpg(um.pid, signal.SIGTERM)
#			GPIO.output(22, True)
#			while GPIO.input(13) == 1:
#	             		time.sleep(1)
       


except KeyboardInterrupt:
  print "  Quit"
  GPIO.cleanup()
