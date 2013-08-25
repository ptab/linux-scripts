#! /bin/bash

# fail if any environment variable is not initialized
set -u

# fail if any inline command fails
set -e


TEMP_PATH="/mnt/files/temp"
LOGFILE="transmission_tvshow_organizer.log"
TV_SHOW_PATH="/mnt/files/tv"

pushd "$TEMP_PATH" >/dev/null
exec 1>>$LOGFILE
exec 2>>$LOGFILE

function move() {
    FILENAME="$1"
    echo "  Filename to move: $FILENAME"

    # bash does not support non-capturing parentheses and perl regex atoms (only POSIX)
    # if [[ $FILENAME =~ (?:\[.*\])?(?:\ \-\ )?((?:\w+\.?)+)\.[sS]([0-9]?[0-9])[eE]([0-9]?[0-9]).* ]] ; then
    if [[ $FILENAME =~ (\[.*\])?(\ \-\ )?(([[:alnum:]]+[\.\_\ ]?)+)\.[sS]([[:digit:]]?[[:digit:]])[eE]([[:digit:]]?[[:digit:]]).*\.(mkv|avi|mp4) ]] ; then
        NAME="${BASH_REMATCH[3]}"
        SEASON="${BASH_REMATCH[5]}"
        EPISODE="${BASH_REMATCH[6]}"

        # remove dots and _ from the name
        NAME="${NAME//./ }"
        NAME="${NAME//_/ }"

        # remove the trailing 0 from the decimal if it exists
        SEASON="$((10#$SEASON))"
        EPISODE="$((10#$EPISODE))"

        echo "  Found match: $NAME, season $SEASON, episode $EPISODE"

        # add exception to Castle (Castle 2009) and The Office (The Office US)

        DESTINATION_PATH="$TV_SHOW_PATH/$NAME/Season $SEASON/"
        echo -n "  Moving to $DESTINATION_PATH ... "
        mkdir -p "$DESTINATION_PATH"
        mv "$FILENAME" "$DESTINATION_PATH"
        if [[ ! $? -eq 0 ]] ; then
            return 1
        fi
        echo "done"
        return 0
    fi
}

date
echo "-----------------------------------------------------------"
echo "Analyzing torrent: $TR_TORRENT_NAME"
transmission-remote -t "$TR_TORRENT_ID" -f | tail -n +3 | cut -c 35- |
while read f ; do
    FILE=""
    if [[ $f =~ .*\.zip ]]; then
        FILE=`unzip -l "$f" | egrep "mkv|avi|mp4" | egrep -vi "sample" | awk '{print $4}'`

        echo -n "  Extracting $f ... "
        unzip -q "$f"
        echo "done"

    elif [[ $f =~ .*\.rar ]]; then
        FILE=`unrar l "$f" | egrep "mkv|avi|mp4" | egrep -vi "sample" | awk '{print $1}'`
        
        echo -n "  Extracting $f ... "
        unrar e -inul -y "$f"
        echo "done"

    # bash does not seem to support negative lookahead
    # elif [[ $f =~ ^((?![sS]ample).)*\.(mkv|avi|mp4)$ ]]; then
    elif [[ $f =~ .*\.(mkv|avi|mp4) ]] && [[ ! $f =~ .*[sS]ample ]]; then
        FILE="$f"
    else
        echo "$f does not match anything"
    fi

    if [[ -n $FILE ]]; then
        move "$FILE"
        if [[ $? -eq 0 ]]; then
            echo -n "  Removing torrent and data from Transmission... "
            DELETE=`transmission-remote -t "$TR_TORRENT_ID" --remove-and-delete | grep success`
            if [[ -n $DELETE ]]; then
                echo "done"
            else
                echo "failed"
            fi
        fi
    fi
done


echo " "
popd >/dev/null
exit 0
