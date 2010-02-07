# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit toolchain-funcs

DESCRIPTION="CD/DVD image converter using libmirage"
HOMEPAGE="http://proj.mgorny.alt.pl/mirage2iso/"
SRC_URI="http://dl.mgorny.alt.pl/${PN}/${P}.tar.bz2
	test? ( http://dl.mgorny.alt.pl/${PN}/${P}-tests.tar.xz )"

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
	# we have to explicitly pass --bindir to workaround bugs in configure script
	# (EPREFIX in parent environment causes confusion), fixed in r115
	econf \
		--bindir=/usr/bin \
		$(use_with pinentry assuan)
}

src_install() {
	emake DESTDIR="${D}" install || die 'install failed'

	dodoc NEWS README || die 'dodoc failed'
}
