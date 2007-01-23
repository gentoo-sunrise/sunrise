# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs qt4

KEYWORDS="~x86"

DESCRIPTION="View and animate up to three functions in 3D-space in a completely interactive manner."
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=43071"
SRC_URI="http://www.kde-apps.org/content/files/43071-zhu3d-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="$(qt4_min_version 4.0)
		virtual/glu"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! built_with_use ">=x11-libs/qt-4.0" opengl; then
		eerror "x11-libs/qt-4* has to be built with opengl support"
		die "Missing opengl USE flag for x11-libs/qt"
	fi
}

src_compile() {
	qmake SYSDIR="/usr/share/${PN}/system" DOCDIR="/usr/share/doc/${P}/html" || die "qmake failed"
	emake CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dobin zhu3d

	dodoc readme.txt

	dohtml doc/*

	insinto /usr/share/${PN}
	doins -r work system

	doicon system/icons/${PN}.png
	make_desktop_entry ${PN} "Zhu3D: Interactive 3D function viewer" ${PN}.png "Qt;Science;Math"
}
