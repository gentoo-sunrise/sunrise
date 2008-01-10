#!/bin/sh
# 
# This script is used to add and remove our extension from the Firefox
# directory, and is run from 'triggers' when Firefox is installed or
# upgraded, as well as when our package is installed. 
#

firedirs="FIREDIRS"

if [ "$1" = "install" ] ; then
    for d in ${firedirs} ; do
        # Add symlink to the firefox directory that looks like it is part of a
        # currently installed package
        if [ -e "$d/firefox-bin" -a -d "$d/extensions" -a ! -L "$d/extensions/firefox@mugshot.org" ] ; then
	    ln -s /usr/GET_LIBDIR/mugshot/firefox "$d/extensions/firefox@mugshot.org"
        fi
    done
elif [ "$1" = "remove" ] ; then
    for d in ${firedirs} ; do
        # Remove the symlink we've created 
        if [ -L "$d/extensions/firefox@mugshot.org" ] ; then
	    rm "$d/extensions/firefox@mugshot.org"
        fi
    done
else
    echo "Usage firefox-update.sh [install/remove]"
fi
