# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils qt4-r2

DESCRIPTION="Qt-based file manager"
HOMEPAGE="http://www.beesoft.org/index.php?id=bsc"
SRC_URI="http://www.beesoft.org/download/${PN}_${PV}_src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/qt-gui:4
	x11-libs/libX11
	x11-libs/libXext"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	default

	# Drop forced CXXFLAGS
	sed -i -e "/^QMAKE_CXXFLAGS_RELEASE/d" ${PN}.pro || die
	# Set up the help file path
	sed -i \
		-e "s;QApplication::applicationDirPath();\"/usr/share/doc/${PF}/html\";" \
		QBtHelp.cpp || die
}

src_install() {
	dobin ${PN} || die
	dohtml help.en.html || die

	newicon BeesoftCommander.png ${PN}.png || die
	make_desktop_entry ${PN} BSCommander ${PN} "FileManager;Utility;Qt"
}
