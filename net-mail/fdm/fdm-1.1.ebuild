# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="fetch, filter and deliver mail"
HOMEPAGE="http://fdm.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

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
