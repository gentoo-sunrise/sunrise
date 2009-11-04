# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="SSLH lets one accept both HTTPS and SSH connections on the same port"
HOMEPAGE="http://www.rutschle.net/tech/sslh.shtml"
SRC_URI="http://www.rutschle.net/tech/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="net-libs/libnet"
DEPEND="${RDEPEND}
	dev-lang/perl"

src_prepare() {
	sed -e "/^USELIBWRAP=1/d" \
		-e "/strip sslh/d" \
		-e "s/\(\$(LIBS)\)$/\1 ${LDFLAGS}/" -i Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin sslh || die "dobin failed"
	doman sslh.8.gz || die "doman failed"

	newinitd "${FILESDIR}"/sslh.init sslh
	newconfd "${FILESDIR}"/sslh.conf sslh
}
