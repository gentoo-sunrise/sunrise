# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Day of the Tentacle"
HOMEPAGE="http://wiki.scummvm.org/index.php/Day_of_the_Tentacle"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND=">=games-engines/scummvm-0.2.0"

S=${WORKDIR}

src_install() {
	local dir=${GAMES_DATADIR}/${PN}
	insinto "${dir}"

	cdrom_get_cds DOTT.EXE
	einfo "Copying files from CD..."
	doins ${CDROM_ROOT}/DOTT/MONSTER.SOU \
		${CDROM_ROOT}/DOTT/TENTACLE.000 \
		${CDROM_ROOT}/DOTT/TENTACLE.001 || die "doins failed"

	games_make_wrapper ${PN} "scummvm -f -p \"${dir}\" tentacle"
	doicon "${FILESDIR}/${PN}.png" || die "doicon failed"
	make_desktop_entry ${PN} "Day of the Tentacle" ${PN}.png

	prepgamesdirs
}
