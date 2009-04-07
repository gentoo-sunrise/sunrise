# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Audit the security of pre-shared keys selected in WiFi Protected Access (WPA) networks"
HOMEPAGE="http://www.willhackforsushi.com/Cowpatty.html"
SRC_URI="http://www.willhackforsushi.com/code/${PN}/${PV}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/openssl
	net-libs/libpcap"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-Makefile.patch
}

src_compile() {
	emake CC=$(tc-getCC) || \
		die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
	dodoc README AUTHORS CHANGELOG TODO FAQ || die "nothing to read"
	insinto /usr/share/${PN}
	doins *.dump dict || die "no acessory files"
}
