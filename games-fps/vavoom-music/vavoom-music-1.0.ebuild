# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="Enhanced music for Vavoom"
HOMEPAGE="http://www.vavoom-engine.com/"

SRC_URI="doom1? ( mirror://sourceforge/vavoom/vmusic-doom1-${PV}.zip )
	doom2? ( mirror://sourceforge/vavoom/vmusic-doom2-${PV}.zip )
	heretic? ( mirror://sourceforge/vavoom/vmusic-heretic-${PV}.zip )
	hexen? ( mirror://sourceforge/vavoom/vmusic-hexen-${PV}.zip )
	plutonia? ( mirror://sourceforge/vavoom/vmusic-doom1-${PV}.zip
				mirror://sourceforge/vavoom/vmusic-doom2-${PV}.zip
				mirror://sourceforge/vavoom/vmusic-plutonia-${PV}.zip )
	tnt? (	mirror://sourceforge/vavoom/vmusic-doom2-${PV}.zip
			mirror://sourceforge/vavoom/vmusic-tnt-${PV}.zip )
	!doom1? ( !doom2? ( !heretic? ( !hexen? ( !plutonia? ( !tnt? (
		mirror://sourceforge/vavoom/vmusic-doom1-${PV}.zip
		mirror://sourceforge/vavoom/vmusic-doom2-${PV}.zip
		mirror://sourceforge/vavoom/vmusic-heretic-${PV}.zip
		mirror://sourceforge/vavoom/vmusic-hexen-${PV}.zip
		mirror://sourceforge/vavoom/vmusic-plutonia-${PV}.zip
		mirror://sourceforge/vavoom/vmusic-tnt-${PV}.zip
		) ) ) ) ) )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doom1 doom2 heretic hexen plutonia tnt"

RDEPEND="games-fps/vavoom"
DEPEND="app-arch/unzip"

S=${WORKDIR}

use_none() {
	# Returns true if no USE flags have been chosen
	for u in ${IUSE} ; do
		if use "${u}" ; then
			# A USE flag has been chosen
			return 1
		fi
	done
	return 0
}

src_unpack() {
	unpack ${A}

	cd "${S}"
	for u in doom1 doom2 heretic hexen tnt ; do
		if use "${u}" || use_none ; then
			mv "basev/${u}/xmusic.txt" "${u}.txt" || die "mv failed"
		fi
	done
}

src_install() {
	cd "${S}/basev"
	insinto "${GAMES_DATADIR}/vavoom/basev/"
	doins -r * || die "doins failed"

	cd "${S}"
	dodoc *.txt || die "dodoc failed"

	prepgamesdirs
}
