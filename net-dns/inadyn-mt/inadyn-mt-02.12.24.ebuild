# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Dynamic DNS (DynDNS) Update daemon in C that supports multiple services"
HOMEPAGE="http://sourceforge.net/projects/inadyn-mt"
SRC_URI="mirror://sourceforge/${PN}/${PN}.v.${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="!net-dns/inadyn"

S=${WORKDIR}/${PN}

pkg_setup() {
	enewuser ${PN}
}

src_install() {
	dosbin bin/linux/${PN} || die

	# inadyn-mt comes with outdated inadyn man pages - see inadyn-mt bug 2445206
	rm man/inadyn.8
	rm man/inadyn.conf.5
	doman man/* || die
	newman man/inadyn-mt.8 inadyn.8 || die
	newman man/inadyn-mt.conf.5 inadyn.conf.5 || die
	# end workaround

	dohtml readme.html || die

	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die
	newconfd "${FILESDIR}"/${PN}.conf ${PN} || die
}

pkg_postinst() {
	elog "You will need to edit /etc/inadyn-mt.conf before running inadyn-mt"
	elog "for the first time. The format is basically the same as the"
	elog "command line options; see inadyn-mt and inadyn-mt.conf manpages."
}
