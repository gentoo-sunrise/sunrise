# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games

DESCRIPTION="NaturalChimie clone written with clanlib"
HOMEPAGE="http://www.openalchemist.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-games/clanlib-0.8.0[opengl,sdl]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${P}-src

DOCS="NEWS README TODO ChangeLog"

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch"
}

src_install() {
	dogamesbin build/${PN} || die "dogamesbin failed"
	dogamesbin ${PN}-config || die "dogamesbin config failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data skins || die "doins failed"

	dodoc ${DOCS} || die "dodoc failed"

	newicon data/logo.png openalchemist.png
	newicon data/logo_svg.svg openalchemist.svg
	make_desktop_entry ${PN} OpenAlchemist ${PN}

	prepgamesdirs
}
