# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="CD/DVD image converter using libmirage"
HOMEPAGE="http://github.com/mgorny/mirage2iso/"
SRC_URI="http://github.com/downloads/mgorny/${PN}/${P}.tar.bz2
	test? ( http://github.com/downloads/mgorny/${PN}/${P}-tests.tar.xz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pinentry test"

COMMON_DEPEND="dev-libs/libmirage
	pinentry? ( dev-libs/libassuan )"
DEPEND="${COMMON_DEPEND}
	test? ( app-arch/xz-utils )"
RDEPEND="${COMMON_DEPEND}
	pinentry? ( app-crypt/pinentry )"

src_configure() {
	tc-export CC
	econf \
		$(use_with pinentry assuan)
}

src_test() {
	xz -cd "${DISTDIR}"/${P}-tests.tar.xz | \
		tar -x --strip-components 1 || die
	emake check || die
}

src_install() {
	emake DESTDIR="${D}" install || die 'install failed'

	dodoc NEWS README || die 'dodoc failed'
}
