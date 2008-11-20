# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="ldns is a library with the aim to simplify DNS programing in C"
HOMEPAGE="http://www.nlnetlabs.nl/projects/ldns/"
SRC_URI="http://www.nlnetlabs.nl/downloads/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="dev-libs/openssl"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc Changelog README || die "dodoc failed"

	if use examples; then
		docinto examples
		dodoc examples/* || die "dodoc for examples failed"
	fi
}

pkg_postinst() {
	ewarn "The drill binary and the ldns-* utilities were moved into their own"
	ewarn "package. If you need them, install net-dns/ldns-utils."
}
