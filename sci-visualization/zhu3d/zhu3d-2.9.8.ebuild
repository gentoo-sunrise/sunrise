# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils toolchain-funcs qt4

KEYWORDS="~x86"

DESCRIPTION="View and animate up to three functions in 3D-space in a completely interactive manner."
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=43071"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/43071-zhu3d-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=x11-libs/qt-4.0:4
		virtual/glu"
RDEPEND="${DEPEND}"
QT4_BUILT_WITH_USE_CHECK="opengl"

src_compile() {
	eqmake4 ${PN}.pro SYSDIR="/usr/share/${PN}/system" DOCDIR="/usr/share/doc/${P}/html"
	emake CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	dobin zhu3d

	dodoc readme.txt
	dohtml doc/*

	insinto /usr/share/${PN}
	doins -r work system

	doicon system/icons/${PN}.png
	make_desktop_entry ${PN} "Zhu3D: Interactive 3D function viewer" ${PN}.png "Education;Science;Math;Qt"
}
