#!/bin/bash
# backup.sh - Library of functions for backing up moo2 saved games
# Copyright (C) 2010 Daniel Santos <daniel.santos@pobox.com>
# $Header: $
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#set -o functrace
shopt -s extdebug

#############################################################################
# Function    : backupInit
# Arguments   : none
# Description :
#############################################################################
backupInit() {
	cd "${moo2UserDir}" || die

	# Check for good config
	test -z "${backupBaseDir}" && die "backupBaseDir not set in ${configFile}"

	# Get absolute path
	backupDir="${PWD}/${backupBaseDir}"

	# Make sure backupDir is usable or can be created.
	getOrCreateUsableDir "${backupDir}"
}

setFileName() {
	backupBaseName="$1"
	backupFileName="${backupDir}/${backupBaseName}.tgz"
}

getFileName() {
	setFileName "$1"
	typeset -i firstTime=1
	while true; do
		# Name can't be empty
		if [[ ${#backupBaseName} -eq 0 ]]; then

			# Don't complain because not supplied at command line
			if [[ ${firstTime} -eq 0 ]]; then
				echo "Name cannot be empty, try again."
			fi

		# Make sure it doesn't already exist
		elif [[ -e "${backupFileName}" ]]; then
			 echo "File '${backupFileName}' already exists. Please choose another."

		else
			return
		fi

		echo "Please enter a name for this saved set."
		echo -e "Saved set name: \c "
		read
		echo
		setFileName "${REPLY}"
		firstTime=0
	done
}

# Do backup
doBackup() {
	backupInit
	getFileName "$1"
	pushd "${moo2UserDir}/MPS/ORION2" 1>/dev/null || die "Failed to enter directory MPS/ORION!"
	echo "Backing up to '${backupFileName}'..."
	tar czf "${backupFileName}" $(ls SR_R[0-9]* HOF.* LASTRACE.RAC MOX.SET SAVE[0-9]*.GAM 2>/dev/null) || die
	echo "Done!"
	popd 1>/dev/null
}
