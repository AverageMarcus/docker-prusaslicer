#!/bin/sh

if [ "${AUTO_CONVERT_SL1}" = "true" ]; then
  echo "Auto convert enabled.\n.sl1 files in the /home/resin directory will be converted to .ctb."
  /convert.sh &
fi

export HOME=/home
exec /opt/prusaslicer/AppRun
