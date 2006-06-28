#!/bin/bash

if [ -z "$1" ]; then
	echo "error: you need to supply a commit message"
	exit 1
fi
if ! ls *.ebuild >/dev/null; then
	echo "error: you need to be in an ebuild directory"
	exit 1
fi

for i in *.ebuild; do
ebuild $i digest
done
svn add *.ebuild Manifest files/digest-*
svn commit -m "$*"
