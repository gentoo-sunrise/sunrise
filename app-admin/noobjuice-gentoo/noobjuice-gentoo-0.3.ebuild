# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib qt4

DESCRIPTION="The Gentoo base system plugins for the NoobJuice system administration GUI"
HOMEPAGE="http://bobshaffer.net/?page=project_noobjuice_gentoo"
SRC_URI="http://bobshaffer.net/projects/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}
	app-admin/noobjuice-viewer
	>=app-portage/eix-0.18.0
	app-portage/gentoolkit
	app-portage/layman
	>=app-admin/eselect-1.2.3
	x11-terms/xterm"

S="${WORKDIR}/noobjuice-gentoo"

src_configure() {
	eqmake4
}

src_install() {
	insinto /usr/$(get_libdir)/noobjuice/plugins
	doins libnoobjuice-gentoo.so || die "libnoobjuice-gentoo.so not found"
	if use doc ; then
		dohtml doc/* || die "failed to install documentation"
	fi
}
