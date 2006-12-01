#!/bin/sh
# 
# This script is used to add and remove our extension from the Firefox
# directory, and is run from 'triggers' when Firefox is installed or
# upgraded, as well as when our package is installed. 
#


d=/usr/lib/mozilla-firefox

if [ "$1" = "install" ] ; then
    # Add symlink to the firefox directory that looks like it is part of a
    # currently installed package
    if [ -e $d/firefox-bin -a -d $d/extensions -a ! -L $d/extensions/firefox@mugshot.org ] ; then
	ln -s /usr/lib/mugshot/firefox $d/extensions/firefox@mugshot.org
    fi
elif [ "$1" = "remove" ] ; then
    # Remove the symlink we've created 
    if [ -L $d/extensions/firefox@mugshot.org ] ; then
	rm $d/extensions/firefox@mugshot.org
    fi
else
    echo "Usage firefox-update.sh [install/remove]"
fi
