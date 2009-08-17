# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit distutils eutils

MY_P=${P/gns/GNS}-src

DESCRIPTION="Graphical Network Simulator"
HOMEPAGE="http://www.gns3.net/"
SRC_URI="mirror://sourceforge/gns-3/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-svg:4
	>=dev-python/PyQt4-4.1"
RDEPEND="${DEPEND}
	>=app-emulation/dynamips-0.2.8_rc2"
S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}_set_dynamips_path.patch"
	epatch "${FILESDIR}/${P}_set_pemu_path.patch"
}

src_install() {
	distutils_src_install
	doman docs/man/${PN}.1 || die "Installing man pages failed"
	insinto /usr/libexec/${PN}
	doins "${S}/pemu/pemuwrapper.py" || die "Failed to install pemuwrapper.py"
}
