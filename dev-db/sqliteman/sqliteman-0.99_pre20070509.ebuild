# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="sqliteman-0.99"

DESCRIPTION="simple but powerfull Sqlite3 GUI database manager"
HOMEPAGE="http://sqliteman.sourceforge.net/"
SRC_URI="mirror://sourceforge/sqliteman/${P/_pre/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=x11-libs/qt-4.2
		>=dev-db/sqlite-3.0"
DEPEND="${RDEPEND}
		dev-util/cmake"


S=${WORKDIR}/${MY_P}

src_compile() {
	if  ! built_with_use x11-libs/qt sqlite3; then
		eerror "sqliteman requires that x11-libs/qt will be"
		eerror "compiled with sqlite3 support"
		die "Please, rebuild x11-libs/qt with the \"sqlite3\" USE flag."
	fi
	cmake . \
		-DCMAKE_INSTALL_PREFIX:PATH=/usr \
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		|| die "cmake failed"
	emake || die "Compile Failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install Failed!"

	dodoc AUTHORS README

}
