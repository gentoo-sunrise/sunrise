# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A squid redirector to allow easy antivirus file checking"
HOMEPAGE="http://www.samse.fr/GPL/"
SRC_URI="http://www.samse.fr/GPL/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-misc/curl-7.12.1
	virtual/libc
	dev-libs/openssl
	sys-libs/zlib
	app-arch/bzip2
	dev-libs/gmp"
RDEPEND="${DEPEND}
	net-proxy/squid"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-makefile.patch"
	epatch "${FILESDIR}/${P}-log.patch"
	epatch "${FILESDIR}/${P}-path.patch"
	epatch "${FILESDIR}/${P}-conf.patch"
}

src_install() {
	dosbin squidclamav
	insinto /etc
	newins squidclamav.conf.dist squidclamav.conf
	keepdir /var/log/squidclamav
	fowners squid:squid /var/log/squidclamav
	dodoc Changelog README squidclamav.conf.dist clwarn.cgi*
}

pkg_postinst() {
	elog "Add following lines to your squid.conf"
	elog "${HILITE}   redirect_program /usr/sbin/squidclamav ${NORMAL}"
	elog "${HILITE}   redirect_children 15 ${NORMAL} #adjust to your needs"
	elog "and this line to your acl list to prevent loops:"
	elog "${HILITE}   redirector_access deny localhost ${NORMAL}"
}
