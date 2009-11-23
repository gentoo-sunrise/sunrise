# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Epson EPL-5x00L/EPL-6x00L Printer Driver for ghostscript"
HOMEPAGE="http://sourceforge.net/projects/epsonepl"
SRC_URI="http://mesh.dl.sourceforge.net/sourceforge/epsonepl/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="usb"

DEPEND="net-print/cups
	virtual/ghostscript
	net-print/foomatic-filters
	usb? ( virtual/libusb )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-destdir.patch"
}

src_compile() {
	econf $(use_with usb libusb)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"

	insinto /usr/share/ppd/
	doins foomatic_PPDs/* || die "doins failed"

	dodoc ChangeLog FAQ README || die "dodoc failed"
}
