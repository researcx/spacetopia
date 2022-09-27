#!/bin/sh
source ../byond/bin/byondsetup

cd `dirname $0`
isdefined=0
${1+ export isdefined=1}
if [ $isdefined == 0 ] ; then
	echo "Space Station 13 Linux Server Toolkit"
	echo "by researcx (https://github.com/researcx)"
	echo "Parameters: start, stop, update, compile, version"
	exit
fi

LONG=`git --git-dir=../space-station-13/.git rev-parse --verify HEAD`
SHORT=`git --git-dir=../space-station-13/.git rev-parse --verify --short HEAD`
VERSION=`git --git-dir=../space-station-13/.git shortlog | grep -E '^[ ]+\w+' | wc -l`

if [ $1 == "start" ]; then
	DreamDaemon 'goonstation.dmb' -port 5200 -log serverlog.txt -invisible -safe &
elif [ $1 == "stop" ]; then
	pkill DreamDaemon
elif [ $1 == "update" ]; then
	echo 'Downloading latest content from .git'
	git clone https://erikad2k5@bitbucket.org/d2k5productions/space-station-13 ../space-station-13/

	echo 'Checking for updates'
	sh -c 'cd ../space-station-13/ && /usr/bin/git pull origin master'

	LONG=`git --git-dir=../space-station-13/.git rev-parse --verify HEAD`
	SHORT=`git --git-dir=../space-station-13/.git rev-parse --verify --short HEAD`
	VERSION=`git --git-dir=../space-station-13/.git shortlog | grep -E '^[ ]+\w+' | wc -l`


	curl "http://cia.d2k5.com/status/status.php?type=update&ver=$VERSION&rev=$LONG"
	echo ''
elif [ $1 == "compile" ]; then
	echo "Compiling Space Station 13 (Revision: $VERSION)"

	TIME="$(sh -c "time DreamMaker ../space-station-13/goonstation.dme &> build.txt" 2>&1 | grep real)"
	#TIME="testing"

	echo $TIME

        LONG=`git --git-dir=../space-station-13/.git rev-parse --verify HEAD`
        SHORT=`git --git-dir=../space-station-13/.git rev-parse --verify --short HEAD`
        VERSION=`git --git-dir=../space-station-13/.git shortlog | grep -E '^[ ]+\w+' | wc -l`


	BUILD="$(tail -1 build.txt)"
	cp build.txt /usr/share/nginx/html/
	
	curl "http://cia.d2k5.com/status/status.php?type=build&data=$BUILD&ver=$VERSION&time=$TIME&log=http://cia.d2k5.com/build.txt"
elif [ $1 == "version" ]; then
	echo "Version Hash: $LONG ($SHORT)"
	echo "Revision: $VERSION"
	echo "Changes in this version: https://bitbucket.org/d2k5productions/space-station-13/commits/$LONG"
	else
	echo "exiting...";
fi
