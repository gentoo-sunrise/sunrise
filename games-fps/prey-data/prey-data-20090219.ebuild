# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="First person shooter from 3D Realms"
HOMEPAGE="http://icculus.org/prey/ http://www.3drealms.com/prey/"
SRC_URI=""

LICENSE="PREY"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
PROPERTIES="interactive"
RESTRICT="bindist"

PDEPEND="games-fps/prey"
S=${WORKDIR}

GAMES_CHECK_LICENSE="yes"
dir=${GAMES_PREFIX_OPT}/prey
Ddir=${D}/${dir}

src_install() {
	cdrom_get_cds Setup/Data/Base/pak000.pk4 \
		Setup/Data/Base/pak002.pk4 \
		Setup/Data/Base/pak003.pk4

	insinto "${dir}"/base

	einfo "Copying files from Disk 1..."
	doins ${CDROM_ROOT}/Setup/Data/Base/pak00{0,1}.pk4 \
		|| die "copying pak000 and pak001"
	cdrom_load_next_cd
	einfo "Copying files from Disk 2..."
	doins ${CDROM_ROOT}/Setup/Data/Base/pak002.pk4 \
		|| die "copying pak002"
	cdrom_load_next_cd
	einfo "Copying files from Disk 3..."
	doins ${CDROM_ROOT}/Setup/Data/Base/pak00{3,4}.pk4 \
		|| die "copying pak003 and pak004"

	prepgamesdirs
}
