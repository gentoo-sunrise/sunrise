# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

WX_GTK_VER="2.8"

inherit eutils wxwidgets

DESCRIPTION="a C++ wrapper around the public domain SQLite 3.x database"
HOMEPAGE="http://wxcode.sourceforge.net/components/wxsqlite3/"
SRC_URI="mirror://sourceforge/wxcode/wxsqlite3-${PV}.tar.gz"

LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="unicode"

DEPEND="
	x11-libs/wxGTK:2.8[X]
	dev-db/sqlite:3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/wxsqlite3-${PV}"

src_configure() {
	econf \
		$(use_enable unicode) \
		--enable-shared \
		--with-wx-config="${WX_CONFIG}" \
		--with-wxshared \
		--with-sqlite3-prefix=/usr
}

src_install() {
	default

	dodoc Readme.txt
	dohtml -r docs/html/*
	docinto samples
	dodoc -r samples/*
}
