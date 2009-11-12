# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="A library with the aim to simplify DNS programing in C"
HOMEPAGE="http://www.nlnetlabs.nl/projects/ldns/"
SRC_URI="http://www.nlnetlabs.nl/downloads/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples sha2 ssl"

RDEPEND="ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if use sha2; then
		if ! use ssl; then
			die "For sha2 support, you have to enable ssl USE flag too"
		fi
	fi
}

src_compile() {
	econf \
	$(use_enable sha2) \
	$(use_with ssl)

	emake || die "emake failed"
	if use doc; then
		emake doxygen || die "emake doc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc Changelog README || die "dodoc failed"

	if use examples; then
		docinto examples
		dodoc examples/* || die "dodoc for examples failed"
	fi

	if use doc; then
		dohtml doc/html/* || die "dohtml failed"
	fi
}

pkg_postinst() {
	einfo "The drill binary and the ldns-* utilities were moved into their own"
	einfo "package. If you need them, install net-dns/ldns-utils."
}
