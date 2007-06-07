# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="Enhanced graphics and textures for Vavoom"
HOMEPAGE="http://www.vavoom-engine.com/"

SRC_URI="doom1? (	mirror://sourceforge/vavoom/vtextures-doom-${PV}.zip
					mirror://sourceforge/vavoom/vtextures-doom1-${PV}.zip )
	doom2? ( 	mirror://sourceforge/vavoom/vtextures-doom-${PV}.zip
				mirror://sourceforge/vavoom/vtextures-doom2-${PV}.zip )
	heretic? ( mirror://sourceforge/vavoom/vtextures-heretic-${PV}.zip )
	hexen? ( mirror://sourceforge/vavoom/vtextures-hexen-${PV}.zip )
	plutonia? ( mirror://sourceforge/vavoom/vtextures-doom-${PV}.zip
				mirror://sourceforge/vavoom/vtextures-doom2-${PV}.zip
				mirror://sourceforge/vavoom/vtextures-plutonia-${PV}.zip )
	tnt? (	mirror://sourceforge/vavoom/vtextures-doom-${PV}.zip
			mirror://sourceforge/vavoom/vtextures-doom2-${PV}.zip
			mirror://sourceforge/vavoom/vtextures-tnt-${PV}.zip )
	!doom1? ( !doom2? ( !heretic? ( !hexen? ( !plutonia? ( !tnt? (
		mirror://sourceforge/vavoom/vtextures-doom-${PV}.zip
		mirror://sourceforge/vavoom/vtextures-doom1-${PV}.zip
		mirror://sourceforge/vavoom/vtextures-doom2-${PV}.zip
		mirror://sourceforge/vavoom/vtextures-heretic-${PV}.zip
		mirror://sourceforge/vavoom/vtextures-hexen-${PV}.zip
		mirror://sourceforge/vavoom/vtextures-plutonia-${PV}.zip
		mirror://sourceforge/vavoom/vtextures-tnt-${PV}.zip
		) ) ) ) ) )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doom1 doom2 heretic hexen plutonia tnt"

RDEPEND="games-fps/vavoom"
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}

	cd "${S}"
	for u in `ls -1 basev` ; do
		case "${u}" in
			"doom")
				mv "basev/${u}/xgfx.txt" "${u}-gfx.txt"
				mv "basev/${u}/xwalls.txt" "${u}-walls.txt"
				;;
			"doom1")
				mv "basev/${u}/xwalls.txt" "${u}-walls.txt"
				;;
			"doom2")
				;;
			"heretic")
				mv "basev/${u}/xgfx.txt" "${u}-gfx.txt"
				;;
			"hexen")
				mv "basev/${u}/xgfx.txt" "${u}-gfx.txt"
				mv "basev/${u}/xwalls.txt" "${u}-walls.txt"
				;;
			"plutonia")
				;;
			"tnt")
				;;
		esac
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
