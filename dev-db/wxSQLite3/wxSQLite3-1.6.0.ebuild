# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils wxwidgets

DESCRIPTION="a C++ wrapper around the public domain SQLite 3.x database"
HOMEPAGE="http://wxcode.sourceforge.net/components/wxsqlite3/"
SRC_URI="mirror://sourceforge/wxcode/wxsqlite3-${PV}.tar.gz"

LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="unicode"

DEPEND=">=x11-libs/wxGTK-2.6
	=dev-db/sqlite-3*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/wxsqlite3"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile_in.patch"
}

src_compile() {
	export WX_GTK_VER=2.6
	if use unicode; then
		need-wxwidgets unicode || die
	else
		need-wxwidgets gtk2 || die
	fi

	econf \
		$(use_enable unicode) \
		--enable-shared \
		--with-wx-config="${WX_CONFIG}" \
		--with-gtk \
		--with-wxshared \
		--with-sqlite3-prefix=/usr \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc Readme.txt
	dohtml -r docs/html/*
	docinto samples
	dodoc -r samples/*
}
