#!/bin/bash

bugsin=$(ls */*/ChangeLog -d | xargs grep -i bug | grep -oE "[0-9]{2}[0-9]+")
ebuildsin=$(ls */*/ChangeLog -d | xargs grep -il bug | sed -e "s:/ChangeLog::")

declare -a bugs ebuilds cc

a=0
for i in ${ebuildsin}; do
	ebuilds[$a]=${i}
	a=$[ $a+1 ];
done

# second loop
a=0
for i in ${bugsin}; do
	bugs[$a]=${i}
	a=$[ $a+1 ];
done

for ((i=0;i<${#ebuilds[@]};i++)) do
	cc[$i]=$(wget bugs.gentoo.org/${bugs[$i]} -q -O - | sed -e "s:&#64;:@:" | grep "value=.*@gentoo.org" | sed -e 's:[^"]*"\([^@]*\).*:\1:' | sed "s:maintainer-wanted::");
	if [ -z "$1" ] || [ "${cc[$i]/$1}" != "${cc[$i]}" ]; then
		echo ${ebuilds[$i]} - bug ${bugs[$i]} - on CC: ${cc[$i]};
	fi
done
