#!/bin/bash

notifier() {
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
}

# Go to location of this script, incase initiated from elsewhere
cd "$( dirname "${BASH_SOURCE[0]}" )"

# Bring up vagrant box, sync up iso directories
#   (to copy out generated iso) then quit / destroy vm
notifier
echo "Creating ISO"
notifier

vagrant up
vagrant rsync
vagrant destroy -f

notifier
echo "ISO created"
echo "Check ${DIR}/iso_image for your fresh image"
notifier

DISPLAY=:0 notify-send -u low -t 1000 "ISO-Created 'Check ${DIR}/iso_image for your fresh image'"

exit 0
