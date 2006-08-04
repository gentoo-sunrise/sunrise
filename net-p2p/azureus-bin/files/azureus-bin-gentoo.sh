#!/bin/bash

PROGRAM_DIR=##PROGRAM_DIR##		# directory where all the files were extracted

AZ_CONFIG="${HOME}/.Azureus/gentoo.config"
if [ -f ~/.Azureus/gentoo.config ]; then
	. ~/.Azureus/gentoo.config
else
	if [ ! -e ~/.Azureus ]; then
		mkdir ~/.Azureus
		echo "Creating ~/.Azureus..."
	fi

	# Setup defaults
	UI_OPTIONS="--ui=swt"

	# Create the config file
	cat > ${AZ_CONFIG} <<END
# User Interface options:
# web     - web based
# web2    - web based
# console - console based
# swt     - swt (GUI) based
#
# When selecting just 1, use '--ui=<ui>'
# When selecting multiple, use '--uis=<ui>,<ui>'
UI_OPTIONS="--ui=swt"
END

fi

MSG0="ERROR:\nYou must edit this script and change PROGRAM_DIR to point to where you installed Azureus"
MSG1="Attempting to start Azureus..."

AZDIR=./
if [ ! -e id.azureus.dir.file ]; then
	AZDIR=$PROGRAM_DIR
	if [ ! -d $AZDIR ]; then
		echo $MSG0 >&2
		exit -1
	fi
fi

cd ${AZDIR}
echo $MSG1

if [ "$1" != "" ]; then
  java -cp $(java-config -p systray4j,azureus-bin 2>/dev/null) -Djava.library.path="${AZDIR}" org.gudy.azureus2.ui.swt.Main "$1"
else
  java -cp $(java-config -p systray4j,azureus-bin 2>/dev/null) -Djava.library.path="${AZDIR}" org.gudy.azureus2.ui.swt.Main
fi
