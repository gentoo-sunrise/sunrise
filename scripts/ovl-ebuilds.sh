#!/bin/bash
#
# Copyright 2006 Piotr Jaroszyński <peper@aster.pl>
# Distributed under the terms of the GNU General Public License v2

source /etc/make.conf
OVERLAY=""

echo "This will take a while depending on no. of installed packages."
echo "Packages installed not from portage dir:"
echo  
while read EBUILD_PATH; do
        OVERLAY=${EBUILD_PATH%/*/*/*}
        CATEGORY=$(basename ${EBUILD_PATH%/*/*})
        PKG=$(basename ${EBUILD_PATH})

        if [[ ${OVERLAY} != ${LASTOVERLAY} ]]; then
                echo "${OVERLAY}:" 
                LASTOVERLAY=${OVERLAY}
        fi

        echo -e "\t${CATEGORY}/${PKG}"
done < <(bzcat /var/db/pkg/*/*/environment.bz2 | grep EBUILD=/ | grep -v $PORTDIR | sort \
| sed -e 's/EBUILD=//' -e 's/.ebuild//')

unset OVERLAY LASTOVERLAY CATEGORY PKG
