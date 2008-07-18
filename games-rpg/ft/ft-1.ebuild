# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Full Throttle"
HOMEPAGE="http://wiki.scummvm.org/index.php/Full_Throttle"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND=">=games-engines/scummvm-0.2.0"

src_install() {
	local dir=${GAMES_DATADIR}/${PN}

	insinto "${dir}"

	cdrom_get_cds RESOURCE/FT.EXE
	einfo "Copying files from CD..."

	doins ${CDROM_ROOT}/RESOURCE/FT.{LA0,LA1} \
		${CDROM_ROOT}/RESOURCE/MONSTER.SOU || die "doins failed"
	doins -r ${CDROM_ROOT}/RESOURCE/DATA \
		${CDROM_ROOT}/RESOURCE/VIDEO || die "doins -r failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" ft"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Full Throttle" ${PN}.png

	prepgamesdirs
}
