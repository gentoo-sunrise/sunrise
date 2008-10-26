# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="In-System Programmer for 8051 MCUs using usbtiny"
HOMEPAGE="http://s51dude.gforge.lug.fi.uba.ar/"
SRC_URI="http://s51dude.gforge.lug.fi.uba.ar/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-libs/libusb"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_compile() {
	emake PREFIX=/usr || die "Build failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install || die "Install failed"
	dodoc README || die "dodoc failed"
}

pkg_postinst() {
	elog "Before being able to use this software, you need to have a working"
	elog "usbtinyisp board."
	elog "Please read: http://s51dude.gforge.lug.fi.uba.ar/"
}
