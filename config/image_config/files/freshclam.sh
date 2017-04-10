#!/bin/bash
set -exu -o pipefail

DATE=$(date '+%a %b %e')

if [[ `cat /var/log/clamav/freshclam.log|grep daily | tail -n1000` =~ 'up to date' ]]
then
  echo 'OK: Freshclam Current'
  exit 0
elif [[ `cat /var/log/clamav/freshclam.log|grep daily | tail -n1000` =~ 'updated' ]]
then
  echo 'OK: Freshclam Current'
  exit 0
else
  echo 'Error: Freshclam needs updating'
  exit 1
fi
