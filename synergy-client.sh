#!/bin/sh

TITLE="Synergy"
#OWN_HOST=`ifconfig eth0 | grep "inet addr:" | awk '{print $2}' | cut -d : -f 2`
OWN_HOST="192.168.1.65"
CLIENT_HOST="192.168.1.101"
CLIENT_USER="tab"
CLIENT_PORT="222"
DEBUG_LEVEL="INFO"



synergys -f -d $DEBUG_LEVEL 2>&1 | zenity --text-info --width=500 --height=500 &
sleep 1

OWN_HOST=`zenity --entry --entry-text="$OWN_HOST" --title="$TITLE" --text="My address:"`
if [ "$?" == "1" ] ; then
	killall synergys
	exit
fi

CLIENT_HOST=`zenity --entry --entry-text="$CLIENT_HOST" --title="$TITLE" --text="Server address:"`
if [ "$?" == "1" ] ; then
	killall synergys
        exit
fi

ssh -p $CLIENT_PORT $CLIENT_USER@$CLIENT_HOST "synergyc -f -d $DEBUG_LEVEL $OWN_HOST" 2>&1 | zenity --text-info --width=500 --height=500 &
while [ -n "`ps -ef | grep -v grep | grep zenity`" ] ; do
	sleep 2
done

ssh -p $CLIENT_PORT $CLIENT_USER@$CLIENT_HOST "killall synergyc"
killall synergys
exit
