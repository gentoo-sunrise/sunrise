# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="ldns is a library with the aim to simplify DNS programing in C"
HOMEPAGE="http://www.nlnetlabs.nl/projects/ldns/"
SRC_URI="http://www.nlnetlabs.nl/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="drill examples utils"

DEPEND=">=dev-libs/openssl-0.9.7
	utils? ( net-libs/libpcap )"

src_compile() {
	einfo "Buildig libldns"
	econf
	emake || die "libldns compilation failed"

	if use drill; then
		einfo "Building drill"
		cd drill
			econf
			emake || die "drill compilation failed"
		cd ..
	fi

	if use utils; then
		einfo "Building example utilities"
		cd examples
			econf
			emake || die "example utilities compilation failed"
		cd ..
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "libldns installation failed"

	if use drill; then
		cd drill
			emake DESTDIR="${D}" install || die "drill installation failed"
		cd ..
	fi

	if use utils; then
		cd examples
			emake DESTDIR="${D}" install || die "example utilities installation failed"
		cd ..
	fi

	dodoc Changelog README || die "Adding documentation failed"

	if use examples; then
		docinto examples
		dodoc examples/* || die "Adding examples to documentation failed"
	fi
}

pkg_postinst() {
	if use utils; then
		ewarn "You enabled the "utils" USE flag, which installs the example utilities."
		ewarn "Most of them are quite useful, but not all of them are production-ready."
	fi
}
