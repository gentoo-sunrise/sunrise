# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit qt4

DESCRIPTION="A simple program to send and receive data to and from a serial device."
HOMEPAGE="http://www.sourceforge.net/projects/serial-io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4
	dev-libs/libserial"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	eqmake4
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"

	dodoc TODO || die "Failed to install TODO file!"
}




