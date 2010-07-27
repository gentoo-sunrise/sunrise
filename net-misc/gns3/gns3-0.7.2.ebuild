# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2"

inherit eutils python distutils

MY_P=${P/gns/GNS}-src

DESCRIPTION="Graphical Network Simulator"
HOMEPAGE="http://www.gns3.net/"
SRC_URI="mirror://sourceforge/gns-3/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/PyQt4-4.6.1
	x11-libs/qt-gui:4
	x11-libs/qt-svg:4"
RDEPEND="${DEPEND}
	>=app-emulation/dynamips-0.2.8_rc2"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${P}_set_dynamips_path.patch"
	epatch "${FILESDIR}/${P}_set_qemu_path.patch"

	python_convert_shebangs -r 2 .

	distutils_src_prepare
}

src_install() {
	distutils_src_install

	insinto /usr/libexec/${PN}
	doins qemuwrapper/{pemubin,qemuwrapper}.py || die

	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry ${PN} "GNS3" ${PN} "Utility;Emulator"

	doman docs/man/${PN}.1 || die
}
