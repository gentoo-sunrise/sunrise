# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games

DESCRIPTION="Bishoujo-style visual novel set in the fictional Yamaku High School for disabled children"
HOMEPAGE="http://katawa-shoujo.com/"
SRC_URI="http://naodesu.org/files/katawa-shoujo/${P}.tar.bz2"

LICENSE="CCPL-Attribution-NonCommercial-NoDerivs-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-games/renpy:6.13"

S="${WORKDIR}/Katawa Shoujo-linux-x86"

src_install() {
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r game/* || die

	# Workaround for renpy>=6.12
	keepdir "${GAMES_DATADIR}/${PN}/archived" || die

	games_make_wrapper ${PN} "renpy-6.13 '${GAMES_DATADIR}/${PN}'"

	make_desktop_entry ${PN} "Katawa Shoujo"

	if use doc ; then
		dodoc "Game Manual.pdf" || die
	fi

	prepgamesdirs
}
