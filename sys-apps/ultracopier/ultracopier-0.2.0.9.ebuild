# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4-r2

DESCRIPTION="Advanced file copying tool"
HOMEPAGE="http://ultracopier.first-world.info/"
SRC_URI="http://files.first-world.info/${PN}/${PV}/ultracopier-src-${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="debug"
S="${WORKDIR}/${P}/src/"

RDEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4"
DEPEND="${RDEPEND}"

src_prepare() {
	if use debug ; then
		sed -i -r 's/DEBUG_ULTRACOPIER [0-9]+/DEBUG_ULTRACOPIER 100/g' var.h || die "Error when set the debug level"
	else
		sed -i -r 's/DEBUG_ULTRACOPIER [0-9]+/DEBUG_ULTRACOPIER 0/g' var.h || die "Error when set the debug level"
	fi
}

src_install() {
	rm -f lang/fr* lang/en* lang/*.ts
	rm -Rf styles/kde3/
	dobin ultracopier || die "Error when copy the application"
	newicon other/ultracopier-128x128.png ultracopier.png || die "Error when copy the icon"
	domenu other/ultracopier.desktop || die "Error when copy the shortcut"
	insinto /usr/share/ultracopier/ || die "Error when switch of directory"
	doins -r lang/ styles/ || die "Error when copy language and styles"
}
