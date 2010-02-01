# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games cmake-utils

DESCRIPTION="Italian card game called briscola"
HOMEPAGE="http://qbriscola.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src_${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="x11-libs/qt-sql:4[sqlite]
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_install() {
	cmake-utils_src_install
	dodoc README || die
	prepgamesdirs
}
