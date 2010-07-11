# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils games

MY_PN="hexen2"
MY_P="${MY_PN}demo-${PV}"

DESCRIPTION="Demo data for Hexen 2"
HOMEPAGE="http://uhexen2.sourceforge.net/"
SRC_URI="amd64? ( mirror://sourceforge/u${MY_PN}/${MY_P}-linux-x86_64.tgz )
	ppc? ( mirror://sourceforge/u${MY_PN}/${MY_P}-linux-i586.tgz )
	x86? ( mirror://sourceforge/u${MY_PN}/${MY_P}-linux-i586.tgz )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}
dir=${GAMES_DATADIR}/${MY_PN}

src_install() {
	insinto "${GAMES_DATADIR}"/${MY_PN}/demo
	doins -r data1 || die

	# All the docs are regarding uhexen2, rather than the demo data.

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if has_version "games-fps/uhexen2[-demo]" ; then
			ewarn "emerge uhexen2 with its 'demo' USE flag, so that"
			ewarn "it uses the demo data directory. Or run it with:"
			ewarn "   uhexen2 -game demo"
			echo
	else
		einfo "This is just the demo data. To play, emerge a client"
		einfo "such as uhexen2 with its 'demo' USE flag."
		echo
	fi
}
