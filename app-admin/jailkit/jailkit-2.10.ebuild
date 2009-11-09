# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

DESCRIPTION="Allows you to easily put programs and users in a chrooted environment"
HOMEPAGE="http://olivier.sessink.nl/jailkit/"
SRC_URI="http://olivier.sessink.nl/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-ldflags.patch" \
		"${FILESDIR}/${P}-pyc.patch" \
		"${FILESDIR}/${P}-destdir.patch"
	eautoreconf
}

src_install() {
	dodir /etc
	cp /etc/shells "${D}"/etc/shells || die
	emake DESTDIR="${D}" install || die "emake install failed"
	doinitd "${FILESDIR}/jailkit" || die
}

pkg_postrm() {
	elog "If you want to keep your system clean, don't forget to remove"
	elog "the line containing /usr/sbin/jk_chrootsh from /etc/shells."
}
