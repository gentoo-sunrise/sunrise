# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Multiuser IRC proxy with ssl support"
SRC_URI="mirror://berlios/bip/${P}.tar.bz2"
HOMEPAGE="http://bip.berlios.de/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="$DEPEND"

src_compile() {
	local myconf=""
	use ssl || myconf="--disable-ssl"

	econf ${myconf} || die "econf failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	rm -rf "${D}/usr/share/doc/bip/"

	dodoc AUTHORS ChangeLog README IDEAS NEWS TODO
	docinto samples
	dodoc samples/*
}
