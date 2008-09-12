# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="fetch, filter and deliver mail"
HOMEPAGE="http://fdm.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="pcre tdb"

DEPEND="dev-libs/openssl
	pcre? ( dev-libs/libpcre )
	tdb? ( dev-libs/tdb )"
RDEPEND="${DEPEND}"

src_compile() {
	local vars

	use tdb && vars="DB=1"
	use pcre && vars="$vars PCRE=1"

	emake $vars || die "emake failed"
}

src_install() {
	dobin fdm || die "installing binary failed"
	doman fdm.1 fdm.conf.5 || die "Installing man pages failed"

	dodoc CHANGES MANUAL README TODO || die "Installing documentation failed"

	docinto examples
	dodoc examples/* || die "Installing documentation failed"
}

pkg_postinst() {
	enewuser _fdm
}
