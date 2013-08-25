#! /bin/bash
# Launch XBMC in fake fullscreen mode on the secondary screen
# Works with nvidia TwinView

NAME="XBMC Media Center"

# start XBMC, without blocking and being tied to the terminal
xbmc &
disown

# wait for the XBMC window to be drawn
while [ -z "$WINDOW" ] ; do
    sleep 1
    WINDOW=`wmctrl -l | grep "$NAME" | awk '{print $1}'`
done

# set it as the active window
wmctrl i -a $WINDOW

# toggle fullscreen
wmctrl -r :ACTIVE: -b toggle,fullscreen,above

# move it to the left secondary screen
wmctrl -r :ACTIVE: -e 0,0,0,-1,-1
