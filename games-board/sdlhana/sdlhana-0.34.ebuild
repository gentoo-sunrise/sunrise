# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils games

DESCRIPTION="Hanafuda card game"
HOMEPAGE="http://sdlhana.nongnu.org/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="media-libs/libsdl"
RDEPEND="${DEPEND}"

src_install(){
	emake DESTDIR="${D}" install || die "emake install failed"
	doicon src/${PN}.xpm
	make_desktop_entry ${PN} "SDL Hana"
	prepgamesdirs
}
