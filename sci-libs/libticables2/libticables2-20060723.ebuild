# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="library to handle different link cables for TI calculators"
HOMEPAGE="http://lpg.ticalc.org/prj_tilp/"
SRC_URI="mirror://sourceforge/gtktiemu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nls"

DEPEND=">=dev-libs/glib-2
	dev-libs/libusb
	nls? ( sys-devel/gettext )"

RDEPEND="${DEPEND}"

S=${WORKDIR}/libticables

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS LOGO NEWS README ChangeLog docs/api.txt
	dohtml docs/html/*
}

pkg_postinst() {
	einfo "Please read the file:"
	einfo "\"/usr/share/doc/${PF}/README.gz\""
	einfo "if you encounter any problem with a link cable"
}
