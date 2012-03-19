# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils games

DESCRIPTION="GTK Cervi clone"
HOMEPAGE="http://tomi.nomi.cz/"
SRC_URI="http://nomi.cz/download/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo-gtk2-esd.patch
}

src_install() {
	dogamesbin ${PN} || die
	dodoc README || die
	prepgamesdirs
}
