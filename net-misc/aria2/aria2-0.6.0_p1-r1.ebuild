# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

KEYWORDS="~amd64 ~ppc ~x86"

DESCRIPTION="aria2 - The high speed download utility"
HOMEPAGE="http://aria2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/_p/+}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE="bittorrent gnutls metalink nls ssl"

COMMON_DEPEND="ssl? (
			gnutls? ( net-libs/gnutls )
			!gnutls? ( dev-libs/openssl )
		)
		bittorrent? ( gnutls? ( dev-libs/libgcrypt ) )
		metalink? ( >=dev-libs/libxml2-2.6.26 )"
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${COMMON_DEPEND}
	nls? ( virtual/libiconv virtual/libintl )"

S="${WORKDIR}/${P/_p/+}"

src_unpack() {
	unpack ${A}
	# Patch comes from upstream,
	# expected to be removed in the next patch-level
	cd "${S}/src"
	epatch "${FILESDIR}/${P}-http_header.patch"
}

src_compile() {
	use ssl && \
		myconf="${myconf} $(use_enable gnutls) $(use_enable !gnutls openssl)"
	econf \
		$(use_enable nls) \
		$(use_enable metalink) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin src/aria2c
	dodoc README AUTHORS TODO NEWS
}
