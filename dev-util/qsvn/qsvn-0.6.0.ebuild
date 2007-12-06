# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

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

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e 's/qmake-qt4/qmake/' src/CMakeLists.txt
	sed -i -e 's/moc-qt4/moc/' src/CMakeLists.txt
	sed -i -e 's/uic-qt4/uic/' src/CMakeLists.txt
	sed -i -e 's/QT_INCLUDES/QT4_INCLUDES/' src/CMakeLists.txt
}

src_compile() {
	local mycmakeargs
	if use debug ; then
		mycmakeargs='-D CMAKE_BUILD_TYPE="Debug"'
	else
		mycmakeargs='-D CMAKE_BUILD_TYPE="Release"'
	fi
	cd "${S}"
	mkdir build
	cd build
	cmake "${mycmakeargs}" -D CMAKE_INSTALL_PREFIX="/usr" ../src || die "cmake failed"
	emake || die "emake failed"
}

src_install() {
	cd build

	emake DESTDIR="${D}" install || die "install failed"
	dodoc ../ChangeLog
}
