# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Almost exact clone of Liero"
HOMEPAGE="http://open.liero.be/"
SRC_URI="http://stepien.cc/~jan/gentoo/distfiles/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	|| ( dev-util/jam dev-util/ftjam )"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-gcc-4.3.patch
}

src_compile() {
	jam -qa || die "jam failed"
}

src_install() {
	dogamesbin openliero || die "dogamesbin failed"
	prepgamesdir
}

pkg_postinst() {
	elog "${PN} requires the original Liero files in order to run properly."
	elog "Visit http://www.liero.be/ and download a Liero package. Unpack it"
	elog "and run ${PN} inside a directory with Liero."
}
