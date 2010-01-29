# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils qt4-r2 versionator

MY_PV="$(replace_version_separator 3 '.')"
DESCRIPTION="BSCommander is a Qt based file manager"
HOMEPAGE="http://www.beesoft.org/index.php?id=bsc"
SRC_URI="http://www.beesoft.org/download/${PN}_${MY_PV}_src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=">=x11-libs/qt-4.3.2:4
	x11-libs/libX11
	x11-libs/libXext"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i -e "/^CXXFLAGS.*/s:-pipe -O4:${CXXFLAGS}:" \
		Makefile || die "sed failed on Makefile"
	sed -i -e "/^QMAKE_CXXFLAGS_RELEASE.*/s:-O4:${CXXFLAGS}:" \
		${PN}.pro || die "sed failed on ${PN}.pro"
}

src_install() {
	dobin ${PN} || die "dobin failed"

	insinto /usr/share/${PN}
	# shouldn't it be dohtml?
	doins help.en.html || die "doins failed"

	newicon BeesoftCommander.png ${PN}.png
	make_desktop_entry ${PN} BSCommander ${PN} "FileManager;Utility;Qt"
}
