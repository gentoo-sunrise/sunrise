# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Library implementing the SSH2 protocol."
HOMEPAGE="http://www.libssh2.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-libs/openssl
	sys-libs/zlib"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-configure.patch"
	epatch "${FILESDIR}/${P}-banner-wait.patch"
	epatch "${FILESDIR}/${P}-channel-failure.patch"
	epatch "${FILESDIR}/${P}-peer-shutdown.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
