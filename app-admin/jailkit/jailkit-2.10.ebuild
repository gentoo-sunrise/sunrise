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
		"${FILESDIR}/${P}-noshells.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	doinitd "${FILESDIR}/jailkit"
}

pkg_postinst() {
	ebegin "Updating /etc/shells"
	( grep -v "^/usr/sbin/jk_chroots$" "${ROOT}"etc/shells; echo "/usr/sbin/jk_chroots" ) > "${T}"/shells
	mv -f "${T}"/shells "${ROOT}"etc/shells
	eend $?
}

pkg_postrm() {
	elog "If you want to keep your system clean, don't forget to remove"
	elog "the line containing /usr/sbin/jk_chrootsh from /etc/shells."
}
