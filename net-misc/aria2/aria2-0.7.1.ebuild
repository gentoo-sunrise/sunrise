# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

KEYWORDS="~amd64 ~ppc ~x86"

MY_P=${P/_p/+}

DESCRIPTION="aria2 - The high speed download utility"
HOMEPAGE="http://aria2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE="ares bittorrent gnutls metalink nls ssl"

COMMON_DEPEND="ssl? (
			gnutls? ( net-libs/gnutls )
			!gnutls? ( dev-libs/openssl )
			)
		ares? ( >=net-dns/c-ares-1.3.0 )
		bittorrent? ( gnutls? ( dev-libs/libgcrypt ) )
		metalink? ( >=dev-libs/libxml2-2.6.26 )"
DEPEND="${COMMON_DEPEND}
		nls? ( sys-devel/gettext )"
RDEPEND="${COMMON_DEPEND}
		nls? ( virtual/libiconv virtual/libintl )"

S=${WORKDIR}/${MY_P}

src_compile() {
	use ssl && \
		myconf="${myconf} $(use_with gnutls) $(use_with !gnutls openssl)"
	econf \
		$(use_with ares libares) \
		$(use_with metalink libxml2) \
		$(use_enable nls) \
		$(use_enable metalink) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin src/aria2c
	dodoc ChangeLog README AUTHORS TODO NEWS
}
