# utils.sh - Library of general utility functions
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
#shopt -s extdebug

# Steal pretty colors from /etc/init.d/functions
eval $(egrep '(GOOD|WARN|BAD|NORMAL|HILITE|BRACKET)=' /etc/init.d/functions.sh)

warn() {
	echo "${WARN}WARNING${NORMAL}: $*" >&2
}

die() {
	echo "${BAD}ERROR${NORMAL}$(test $# -eq 0 || echo ": $*")" >&2
	backtrace
	exit 1
}

assert() {
	echo "${BAD}Internal Script Error${NORMAL}: $*" >&2
	backtrace
	exit 1
}

#############################################################################
# Function    : backtrace
# Arguments   : none
# Description : Prints out a cute Bash call stack backtrace.  For it to fully
#				function, you must set -o functrace and shopt -s extdebug
#############################################################################
backtrace() {
	typeset -i i frame=0 arg=0
	while caller $frame > /dev/null; do
		echo "${HILITE}[${frame}]${NORMAL} $(caller $frame)"

		((argsInFrame = BASH_ARGC[frame]))

		for ((i = 0; i < argsInFrame; ++i)); do
			((arg = totalArgs + argsInFrame - i - 1))
			echo "    ${HILITE}\$$i${NORMAL}: ${BASH_ARGV[${arg}]}"
		done
		((totalArgs += argsInFrame))
		((++frame))
	done

	if set -o|egrep 'functrace.*off' > /dev/null; then
		echo "backtrace will not work without set -o functrace"
	fi

	if shopt|egrep 'extdebug.*off' >> /dev/null; then
		echo "To see parameters in backtraces, use shopt -s extdebug"
	fi
}

#############################################################################
# Function    : getOrCreateUsableDir
# Arguments   : directory_name
# Description : Verifies that directory_name is fully usable (rwx) or creates
#				it.
#############################################################################
getOrCreateUsableDir() {
	(($#)) || assert "getOrCreateUsableDir takes one or more arguments"

	while (($#)); do

		# Make sure no non-directories are in the way
		test -e "$1" -a ! -d "$1" &&
			die "A non-directory file named $1 is in the way"

		# Create if missing
		test -d "$1" || mkdir -p "$1" || die

		# Verify fully usable
		test -r "$1" || die "No read permissions to $1"
		test -w "$1" || die "No write premissions to $1"
		test -x "$1" || die "No execute (browse) premissions to $1"
		shift

	done
}

# vim:ts=4