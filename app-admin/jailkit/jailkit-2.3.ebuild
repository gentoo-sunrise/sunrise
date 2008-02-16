# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Allows you to easily put programs and users in a chrooted environment"
HOMEPAGE="http://olivier.sessink.nl/jailkit/"
SRC_URI="http://olivier.sessink.nl/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-destdir.patch"
	epatch "${FILESDIR}/${P}-nostrip.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	doinitd "${FILESDIR}/jailkit"
}

pkg_postinst() {
	elog "Don't forget to add /usr/sbin/jk_chrootsh to /etc/shells."
}

pkg_postrm() {
	elog "If you want to keep your system clean, don't forget to remove"
	elog "the line containing /usr/sbin/jk_chrootsh from /etc/shells."
}
