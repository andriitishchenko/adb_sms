#! /bin/bash
tmp=$(adb -s S5660a5eda6fb shell dumpsys power | grep mPowerState=[0-9]) 
poverValue=$(expr "$tmp" : '.*mPowerState=\([^\S]*\)\s')
echo "mPowerState=$poverValue"
# 0 - screen of
# 1 - screen ligth off (britness)
# 3 - active
# 7 - lock screen 


function pressPower {
	adb -s S5660a5eda6fb shell << !
sendevent /dev/input/event2 1 107 1;
sleep 1;
sendevent /dev/input/event2 1 107 0;
sleep 1;
exit;
!
}

function pressHome {
    adb -s S5660a5eda6fb shell input keyevent 4;
}

function swipeUnlock {
	adb -s S5660a5eda6fb shell << !
sendevent /dev/input/event1 3 53 50;      
sendevent /dev/input/event1 3 54 330;    
sendevent /dev/input/event1 3 48 1;
sendevent /dev/input/event1 3 50 52;
sendevent /dev/input/event1 0 2 0;
sendevent /dev/input/event1 0 0 0;

sendevent /dev/input/event1 3 53 300;     
sendevent /dev/input/event1 3 54 330;     
sendevent /dev/input/event1 3 48 1;
sendevent /dev/input/event1 3 50 66;
sendevent /dev/input/event1 0 2 0;
sendevent /dev/input/event1 0 0 0;

sendevent /dev/input/event1 3 53 0;   
sendevent /dev/input/event1 3 54 0;
sendevent /dev/input/event1 3 48 0;
sendevent /dev/input/event1 3 50 0;
sendevent /dev/input/event1 0 2 0;
sendevent /dev/input/event1 0 0 0;
sleep 1;
exit;
!
}

function sendSMS {
	adb -s S5660a5eda6fb shell << !
input keyevent 4;
am start -a android.intent.action.SENDTO -d sms:"$1" --es sms_body "$2" --ez exit_on_sent true;
sleep 1;
input keyevent 22;
input keyevent 66;
sleep 1;
exit;
!
}


case "$poverValue" in
1 | 3)
    pressHome
    ;;

7)
    pressHome
    swipeUnlock
    ;;

*)
    pressPower
	swipeUnlock
    ;;
esac


sendSMS "$1" "$2"
#sendSMS "+380686513841" "Hey lalal! SMS"


