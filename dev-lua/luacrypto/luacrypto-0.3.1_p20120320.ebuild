# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools

DESCRIPTION="Lua Crypto Library"
HOMEPAGE="https://github.com/mkottman/luacrypto.git" # most active fork
SRC_URI="mirror://github/hasufell/tinkerbox/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1
	dev-libs/openssl:0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf \
		--htmldir=/usr/share/doc/${PF}/html
}

src_test() {
	emake test
}
