#/bin/bash

VOL=$(amixer get Master | awk -F'[][]' '/%/ { if ($7 == "off") { print "00" } else { print $2 }}')
echo $VOL
