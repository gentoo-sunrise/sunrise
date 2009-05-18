# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils autotools

DESCRIPTION="secure mesh networking VPN"
HOMEPAGE="http://e-x-a.org/"
SRC_URI="http://e-x-a.org/releases/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-libs/gnutls"
DEPEND=" ${RDEPEND}
	sys-devel/automake"

src_prepare() {
	rm -r src/stunproxy #incomplete, don't bother with it.
	./autogen.sh
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README || die "doc'ing README failed"
}
