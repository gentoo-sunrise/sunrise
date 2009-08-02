# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils qt4

DESCRIPTION="Utility to encode and decode Game Genie (tm) codes"
HOMEPAGE="http://games.technoplaza.net/ggencoder/qt/"
SRC_URI="http://games.technoplaza.net/${PN}/qt/history/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

DEPEND="x11-libs/qt-gui:4[debug?]"
RDEPEND="${DEPEND}"

S="${S}/source"

src_configure() {
	eqmake4
}

src_install() {
	dobin ${PN} || die "dobin failed"
	cd ..
	dodoc docs/ggencoder.txt || die "dodoc failed"

	if use doc ; then
		dohtml -r apidocs/html/* || die "dohtml failed"
	fi
}

