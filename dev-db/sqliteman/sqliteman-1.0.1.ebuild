# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Simple but powerfull Sqlite3 GUI database manager"
HOMEPAGE="http://sqliteman.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=x11-libs/qt-4.2
		>=dev-db/sqlite-3.0"
DEPEND="${RDEPEND}
		dev-util/cmake"

src_compile() {
	if  ! built_with_use ">=x11-libs/qt-4.2" sqlite3; then
		eerror "sqliteman requires x11-libs/qt-4 compiled with sqlite3 support"
		die "Please, rebuild x11-libs/qt-4 with the \"sqlite3\" USE flag."
	fi
	cmake . \
		-DCMAKE_INSTALL_PREFIX:PATH=/usr \
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		|| die "cmake failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS README

}
