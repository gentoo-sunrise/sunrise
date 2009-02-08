# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="A keepalive daemon for vpnc on Linux systems."
HOMEPAGE="http://code.google.com/p/vpncwatch/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="net-misc/vpnc"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc4.3.patch"
	epatch "${FILESDIR}/${P}-literal.patch"
	epatch "${FILESDIR}/${P}-Makefile.patch"
}

src_compile() {
	emake CC=$(tc-getCC) || \
		die "compilation failed"
}

src_install() {
	dobin vpncwatch || die "failed to install ${PN}"
	dodoc README ChangeLog AUTHORS || die "doc install failed"
}
