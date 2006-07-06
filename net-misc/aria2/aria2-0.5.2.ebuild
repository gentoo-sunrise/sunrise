# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="aria2 - The high speed download utility"
HOMEPAGE="http://aria2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="bittorrent gnutls nls ssl"

RDEPEND="ssl? ( gnutls? ( net-libs/gnutls )
		!gnutls? ( dev-libs/openssl )
		)
	 bittorrent? ( gnutls? ( dev-libs/libgcrypt ) )
	 nls? ( virtual/libiconv virtual/libintl )"
DEPEND="${RDEPEND}"

src_compile() {
	use ssl && \
		myconf="${myconf} $(use_enable gnutls) $(use_enable !gnutls openssl)"
	econf \
		$(use_enable nls) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin src/aria2c
	dodoc README AUTHORS TODO NEWS
}
