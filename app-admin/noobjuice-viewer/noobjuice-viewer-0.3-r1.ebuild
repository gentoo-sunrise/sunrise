# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit qt4-r2

DESCRIPTION="Viewer for the NoobJuice plugin-based GUI for Gentoo system administration."
HOMEPAGE="http://bobshaffer.net/?page=project_noobjuice_viewer"
SRC_URI="http://bobshaffer.net/projects/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4[qt3support]"
RDEPEND="${DEPEND}"
S="${WORKDIR}"/noobjuice

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dohtml doc/* || die "unable to install documentation"
}
