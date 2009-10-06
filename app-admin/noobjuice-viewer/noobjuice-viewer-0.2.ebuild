# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4

DESCRIPTION="Viewer for the NoobJuice plugin-based GUI for Gentoo system administration."
HOMEPAGE="http://bobshaffer.net/?page=project_noobjuice_viewer"
SRC_URI="http://bobshaffer.net/projects/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"
S="${WORKDIR}"/noobjuice

src_configure() {
	eqmake4 noobjuice.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dohtml doc/* || die "unable to install documentation"
}

