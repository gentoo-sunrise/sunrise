# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit cmake-utils

DESCRIPTION="GUI frontend to the Subversion revision system"
HOMEPAGE="http://ar.oszine.de/projects/qsvn/"
SRC_URI="http://ar.oszine.de/projects/qsvn/chrome/site/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

RDEPEND="x11-libs/qt:4
	dev-util/subversion"
DEPEND="${DEPEND}
	>=dev-util/cmake-2.4.0"

S="${WORKDIR}/${P}/src"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e 's/qmake-qt4/qmake/' \
		-e 's/moc-qt4/moc/' \
		-e 's/uic-qt4/uic/' \
		-e 's/QT_INCLUDES/QT4_INCLUDES/' CMakeLists.txt || die "sed failed"
}

src_install() {
	cmake-utils_src_install
	dodoc ../{ChangeLog,README}
}
