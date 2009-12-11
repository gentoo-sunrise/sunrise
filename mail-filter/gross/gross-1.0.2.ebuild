# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="gross - Greylisting of suspicious sources"
HOMEPAGE="http://code.google.com/p/gross/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ares milter"

DEPEND="ares?	( net-dns/c-ares )
	milter?	( || ( mail-filter/libmilter mail-mta/sendmail ) )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-fix-paths-and-rm-getline.patch
}

src_configure() {
	econf \
		--sysconfdir=/etc/mail/gross \
		$(use_enable milter) \
		$(use_enable ares dnsbl)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	diropts -o nobody -g nobody
	dodir /var/run/grossd || die "dodir failed"
	keepdir /var/db/grossd || die "dodir db failed"
	dodoc ChangeLog NEWS README doc/examples/* || die "dodoc failed"
	newinitd "${FILESDIR}"/grossd.initd grossd || die "newinitd failed"
	newconfd "${FILESDIR}"/grossd.confd grossd || die "newconfd failed"
}
