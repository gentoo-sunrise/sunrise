# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Weighted Policy daemon for Postfix"
HOMEPAGE="http://www.policyd-weight.org/"
SRC_URI="http://www.policyd-weight.org/old/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="perl-core/Sys-Syslog
	 dev-perl/Net-DNS
	 >=mail-mta/postfix-2.1"

pkg_setup() {
	enewgroup 'polw'
	enewuser 'polw' -1 -1 -1 'polw'
}

src_install() {
#Makefile does not install. Performing manual install
	exeinto /usr/lib/postfix
	doexe policyd-weight
	fowners root:wheel /usr/lib/postfix/policyd-weight
	doman man/man5/*.5 man/man8/*.8
	dodoc *.txt
	insinto /etc
	newins policyd-weight.conf.sample policyd-weight.conf
	newinitd "${FILESDIR}/${PN}.init.d" "${PN}"
}
