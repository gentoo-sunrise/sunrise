# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="3D models of Doom/Heretic/Hexen/Strife for Vavoom"
HOMEPAGE="http://www.vavoom-engine.com/"

SRC_URI="doom? ( mirror://sourceforge/vavoom/vmodels-doom-${PV}.zip )
	heretic? ( mirror://sourceforge/vavoom/vmodels-heretic-${PV}.zip )
	hexen? ( mirror://sourceforge/vavoom/vmodels-hexen-${PV}.zip )
	strife? ( mirror://sourceforge/vavoom/vmodels-strife-${PV}.zip )
	!doom? ( !heretic? ( !hexen? ( !strife? (
		mirror://sourceforge/vavoom/vmodels-doom-${PV}.zip
		mirror://sourceforge/vavoom/vmodels-heretic-${PV}.zip
		mirror://sourceforge/vavoom/vmodels-hexen-${PV}.zip
		mirror://sourceforge/vavoom/vmodels-strife-${PV}.zip ) ) ) )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doom heretic hexen strife"

DEPEND="app-arch/unzip"
RDEPEND="games-fps/vavoom"

RESTRICT="nomirror"

S=${WORKDIR}

src_install() {
	insinto "${GAMES_DATADIR}/vavoom/"
	doins -r * || die "doins failed"

	prepgamesdirs
}
