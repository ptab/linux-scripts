#!/bin/bash

HOST="veetle.com"
#PORT=`netstat -atunp 2>/dev/null | grep libveetle-cor | grep LISTEN | tail -n 1 | awk {'print $4'} | cut -d \: -f 2`
PORT=`netstat -atunp 2>/dev/null | grep libveetle-cor | grep ESTABLISHED | awk {'print $4'} | grep 127\.0\.0\.1 | cut -d \: -f 2`

IP=`ping -c 1 $HOST | grep PING | cut -d \( -f 2 | cut -d \) -f 1`
CHANNEL=`echo $1 | cut -d \# -f 2`

echo "Calculated link: http://127.0.0.1:$PORT/$IP,$CHANNEL"

if [ -n ${PORT} ] && [ -n ${IP} ] && [ -n ${CHANNEL} ] ; then
	mplayer http://127.0.0.1:$PORT/$IP,$CHANNEL
fi
