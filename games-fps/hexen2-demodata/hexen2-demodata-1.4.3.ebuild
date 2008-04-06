# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_PN="hexen2"

DESCRIPTION="Demo data for Hexen 2"
HOMEPAGE="http://uhexen2.sourceforge.net/"
SRC_URI="mirror://sourceforge/uhexen2/hexen2demo-${PV}-linux-i586.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/hexen2demo-${PV}
dir=${GAMES_DATADIR}/${MY_PN}

src_install() {
	insinto "${dir}"/demo
	doins -r data1 || die "doins data1 failed"

	# All the docs are regarding uhexen2, rather than the demo data.

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if has_version "games-fps/uhexen2" ; then
		if ! built_with_use "games-fps/uhexen2" demo ; then
			ewarn "emerge uhexen2 with its 'demo' USE flag, so that"
			ewarn "it uses the demo data directory. Or run it with:"
			ewarn "   uhexen2 -game demo"
			echo
		fi
	else
		einfo "This is just the demo data. To play, emerge a client"
		einfo "such as uhexen2 with its 'demo' USE flag."
		echo
	fi
}
