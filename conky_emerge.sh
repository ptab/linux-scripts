#!/bin/sh

TIMESTAMP_CHK="/usr/portage/metadata/timestamp.chk"
UPDATE_WORLD_FILE="$HOME/apps/scripts/.update_world"
UPDATE_DATA_FILE="$HOME/apps/scripts/.update_data"

function usage {
	echo "usage: $0 [check | get [packages | upgrades | new | downgrades | size | size-unit] | current [package | count | total] ]"
}

case "$1" in
	"check")
		emerge -uDNpv world > $UPDATE_WORLD_FILE

		PACKAGES=0
		UPGRADES=0
		NEW=0
		DOWNGRADES=0
		SIZE="0 kB"
		
		TYPES=`grep Total: $UPDATE_WORLD_FILE`
#		TYPES='Total: 24 packages (24 upgrades, 4 new), Size of downloads: 68,988 kB'
		REGEX='Total: ([0-9]+) packages?.*, Size of downloads: (.*)'


		if [[ $TYPES =~ $REGEX ]]; then
			let "NUM_MATCHES = ${#BASH_REMATCH[@]} - 1"
			PACKAGES="${BASH_REMATCH[1]}"
			#UPGRADES="${BASH_REMATCH[2]}"
			#NEW_EXISTS=`echo $TYPES | grep new`
			#if [ ! -z "${NEW_EXISTS}" ]; then
			#	NEW="${BASH_REMATCH[4]}"
			#else
			#	NEW=0
			#fi
			#DOWNGRADES_EXISTS=`echo $TYPES | grep downgrades`
			#if [ ! -z "${DOWNGRADES_EXISTS}" ]; then
			#	DOWNGRADES=$BASH_REMATCH[4 + 2]
			#else
			#	DOWNGRADES=0
			#fi
			#SIZE="${BASH_REMATCH[$NUM_MATCHES]}"
			SIZE="${BASH_REMATCH[2]}"
		fi

		echo "Packages: $PACKAGES" > $UPDATE_DATA_FILE
		echo "Upgrades: $UPGRADES" >> $UPDATE_DATA_FILE
		echo "New: $NEW" >> $UPDATE_DATA_FILE
		echo "Downgrades: $DOWNGRADES" >> $UPDATE_DATA_FILE
		echo "Size: $SIZE" >> $UPDATE_DATA_FILE

		#cat $UPDATE_DATA_FILE
		;;
	"get")
		case "$2" in
		        "packages")
				echo `grep "Packages:" $UPDATE_DATA_FILE | awk {'print $2'}`
				;;
			
			"upgrades")
				echo `grep "Upgrades:" $UPDATE_DATA_FILE | awk {'print $2'}`
				;;
					
			"new")
				echo `grep "New:" $UPDATE_DATA_FILE | awk {'print $2'}`
				;;
			
			"size")
				echo `grep "Size:" $UPDATE_DATA_FILE | awk {'print $2'}`
				;;
				
			"size-unit")
				echo `grep "Size:" $UPDATE_DATA_FILE | awk {'print $3'}`
				;;
			
			*)      
				usage
				;;
		esac
		;;

	"current")
		case "$2" in
			"package")
				echo `genlop -cn | grep \* | awk {'print $2'}`
				;;
			"count")
				echo `genlop -cn | grep Currently | awk {'print $3'}`
				;;
			"total")
				echo `genlop -cn | grep Currently | awk {'print $6'}`
				;;
			"eta")
				ETA=`genlop -cn | grep ETA`
				if [ ! -z `echo $ETA | grep less` ]; then
					echo `echo $ETA | cut -d : -f 2`
				else
					echo `echo $ETA | awk {'print $2'}`m `echo $ETA | awk {'print $5'}`s
				fi
				;;
			*)
				usage
				;;
		esac
		;;
	*)
		usage
		;;
esac
exit 0
