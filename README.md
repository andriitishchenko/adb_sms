# adb_sms
Sumsung s5660 (320 x 480)


````
 $./sms.sh "+380686513841" "Hey lalal! SMS lalala"

````


> adb shell input keyevent 26 not works for me so I unlock the phone with "sendevent"

> adb shell service call isms not works too

````
 $ adb devices
List of devices attached 
S5660a5eda6fb	device    <<<this is my device connected over USB
````

Lets find touch events
````
 $ adb -s S5660a5eda6fb shell getevent
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
````
0001 = 1
006b = 107
00000001 = 1
00000000 = 0
````

Power button event looks like this
````
sendevent /dev/input/event2 1 107 1;  // press
sendevent /dev/input/event2 1 107 0;  // release
````

Unlock
````
$ adb -s S5660a5eda6fb shell << !
sendevent /dev/input/event2 1 107 1;
sleep 1;
sendevent /dev/input/event2 1 107 0;
sleep 1;
input keyevent 82
sleep 1;
exit;
!
````

Slider Unlock
````
$ adb -s S5660a5eda6fb shell << !
sendevent /dev/input/event2 1 107 1;
sleep 1;
sendevent /dev/input/event2 1 107 0;
sleep 1;
sendevent /dev/input/event1 3 53 50;      <= here is start x=50
sendevent /dev/input/event1 3 54 330;     <= here is start y=330
sendevent /dev/input/event1 3 48 1;
sendevent /dev/input/event1 3 50 52;
sendevent /dev/input/event1 0 2 0;
sendevent /dev/input/event1 0 0 0;

sendevent /dev/input/event1 3 53 300;     <= here is finish x=300
sendevent /dev/input/event1 3 54 330;     <= here is finish y=330
sendevent /dev/input/event1 3 48 1;
sendevent /dev/input/event1 3 50 66;
sendevent /dev/input/event1 0 2 0;
sendevent /dev/input/event1 0 0 0;

sendevent /dev/input/event1 3 53 0;       <= this block required to finish swipe
sendevent /dev/input/event1 3 54 0;
sendevent /dev/input/event1 3 48 0;
sendevent /dev/input/event1 3 50 0;
sendevent /dev/input/event1 0 2 0;
sendevent /dev/input/event1 0 0 0;

sleep 1;
exit;
!
````

Enter PIN 
````
$ adb -s S5660a5eda6fb shell << !
input text 0000;                   <= this is pin for unlock
sleep 1;
input keyevent 66;
sleep 1;
exit;
!
````



Key Code=Events

0=KEYCODE_UNKNOWN

1=KEYCODE_MENU

2=KEYCODE_SOFT_RIGHT

3=KEYCODE_HOME

4=KEYCODE_BACK

5=KEYCODE_CALL

6=KEYCODE_ENDCALL

7=KEYCODE_0

8=KEYCODE_1

9=KEYCODE_2

10=KEYCODE_3

11=KEYCODE_4

12=KEYCODE_5

13=KEYCODE_6

14=KEYCODE_7

15=KEYCODE_8

16=KEYCODE_9

17=KEYCODE_STAR

18=KEYCODE_POUND

19=KEYCODE_DPAD_UP

20=KEYCODE_DPAD_DOWN

21=KEYCODE_DPAD_LEFT

22=KEYCODE_DPAD_RIGHT

23=KEYCODE_DPAD_CENTER

24=KEYCODE_VOLUME_UP

25=KEYCODE_VOLUME_DOWN

26=KEYCODE_POWER

27=KEYCODE_CAMERA

28=KEYCODE_CLEAR

29=KEYCODE_A

30=KEYCODE_B

31=KEYCODE_C

32=KEYCODE_D

33=KEYCODE_E

34=KEYCODE_F

35=KEYCODE_G

36=KEYCODE_H

37=KEYCODE_I

38=KEYCODE_J

39=KEYCODE_K

40=KEYCODE_L

41=KEYCODE_M

42=KEYCODE_N

43=KEYCODE_O

44=KEYCODE_P

45=KEYCODE_Q

46=KEYCODE_R

47=KEYCODE_S

48=KEYCODE_T

49=KEYCODE_U

50=KEYCODE_V

51=KEYCODE_W

52=KEYCODE_X

53=KEYCODE_Y

54=KEYCODE_Z

55=KEYCODE_COMMA

56=KEYCODE_PERIOD

