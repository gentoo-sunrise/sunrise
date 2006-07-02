# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="aria2 - The high speed download utility"
HOMEPAGE="http://aria2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="bittorrent crypt gnutls nls ssl"

RDEPEND="gnutls? ( net-libs/gnutls )
	 ssl? ( dev-libs/openssl )
	 crypt? ( dev-libs/libgcrypt )
	 nls? ( virtual/libiconv virtual/libintl )"
DEPEND="${RDEPEND}"

pkg_setup() {
	if use bittorrent && ! use openssl && ! ( use gnutls && use crypt ); then
		eerror "For bittorrent, you need either openssl or gnutls and grypt"
		eerror "use flags enabled"
		die "use flag inconsistency"
	fi
}

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_with gnutls) \
		$(use_with ssl openssl) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin src/aria2c
	dodoc README AUTHORS TODO NEWS
}
