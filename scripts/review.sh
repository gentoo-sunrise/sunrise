#!/bin/bash
#
# Stefan Schweizer <genstef@gentoo.org>
# Move a certain revision from sunrise/ to reviewed/
#

if [ -z "$1" ]; then
	echo "You need to supply the revision"
	exit
fi

echo Updating everything to current revision...
svn up
# first-time
#reviewed=$(svn log --verbose --stop-on-copy reviewed | grep "sunrise:[0-9]*)" -o | sed -e "s/sunrise:\([0-9]*\))/\1/")
reviewed=$(svn log reviewed 2>/dev/null | grep "Reviewed up to revision " -m 1 | sed "s:Reviewed up to revision ::")
sunrise=$1

if [ $reviewed -gt $sunrise ]; then
	echo "a newer revision is already reviewed"
	exit
fi

echo Merging in changes...
svn merge sunrise@$reviewed sunrise@$sunrise reviewed
echo Commiting your review
svn ci -m "Reviewed up to revision $1"

