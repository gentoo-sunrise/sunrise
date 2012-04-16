# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="Lua Crypto Library"
HOMEPAGE="https://github.com/LuaDist/luacrypto"
SRC_URI="mirror://github/hasufell/tinkerbox/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-lang/lua-5.1
	dev-libs/openssl:0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	tc-export CC
}

src_prepare() {
	epatch "${FILESDIR}"/20120413-makefile.patch
}

src_install() {
	if use doc; then
		dodoc README
		dohtml -r doc/*
	fi

	emake \
		DESTDIR="${D}" \
		PREFIX="/usr" \
		LIBDIR=$(get_libdir) \
		install
}

pkg_postinst() {
	elog "Note that upstream names the library \"crypto.so\"."
	elog "and not \"libluacrypto.so\"."
}
