# adb_sms
Sumsung s5660
Unlocking the phone configured as Power then Left_Option

> adb shell input keyevent not works for me so I unlock the phone with "sendevent"
> adb shell service call isms not works too

````
 $ adb devices
List of devices attached 
S5660a5eda6fb	device    <<<this is my device connected over USB
````

Lets find touch events
````
 adb -s S5660a5eda6fb shell getevent
add device 1: /dev/input/event4
  name:     "magnetic_sensor"
add device 2: /dev/input/event3
  name:     "accelerometer_sensor"
add device 3: /dev/input/event2     <<<< here is it
  name:     "sec_key"
add device 4: /dev/input/event1    
  name:     "sec_touchscreen"
add device 5: /dev/input/event0
  name:     "sec_jack"
^C
````
Lets get the power button code. Start monitoring events, press Power button (you will see events), press Ctrl+C for stop.
The "event2" is from the sec_key event name above:
````
$ adb -s S5660a5eda6fb shell getevent -v | grep event2
add device 3: /dev/input/event2
/dev/input/event2: 0001 006b 00000001
/dev/input/event2: 0001 006b 00000000
^C

````
Convert hex to dec:
0001 = 1
006b = 107
00000001 = 1
00000000 = 0

Power button event looks like this
````
sendevent /dev/input/event2 1 107 1;  // press
sendevent /dev/input/event2 1 107 0;  // release
````

Unlock
````
adb -s S5660a5eda6fb shell << !
sendevent /dev/input/event2 1 107 1;
sleep 1;
sendevent /dev/input/event2 1 107 0;
sleep 1;
input keyevent 82
sleep 1;
exit;
!
````


