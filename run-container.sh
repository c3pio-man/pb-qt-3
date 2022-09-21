#!/bin/bash

set -ex
if [ -f /.dockerenv ]; then
	echo "Already in container,exit"
	exit 1
fi
Cookiefile=containercookie
Cookie="$(xauth nlist $DISPLAY | sed -e 's/^..../ffff/')" 
echo "$Cookie" | xauth -f "$Cookiefile" nmerge -

./docker/run.py -v ~/.Xauthority:/home/jenkins/.Xauthority -E DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ -e XAUTHORITY=/home/jenkins/cookie -v $(realpath $Cookiefile):/home/jenkins/cookie -v $(realpath .):/BUILD -w /BUILD --  bash
