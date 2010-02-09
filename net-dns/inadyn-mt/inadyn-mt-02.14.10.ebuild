# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

MY_P=${PN}.v.${PV}

DESCRIPTION="Dynamic DNS (DynDNS) Update daemon in C that supports multiple services"
HOMEPAGE="http://sourceforge.net/projects/inadyn-mt"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="+threads +async"

RDEPEND="!net-dns/inadyn"

S=${WORKDIR}/${PN}/${MY_P}

pkg_setup() {
	enewuser ${PN}

	GETHOSTBYNAME_PARAMS=3

	if use threads ; then
		USE_THREADS=1
		if use async ; then
			ASYNC_LOOKUP=1
		fi
	fi
	TARGET_ARCH=linux
}

src_install() {
	cd "${MY_P}"

	dosbin bin/linux/${PN} || die

	# inadyn-mt comes with outdated inadyn man pages - see inadyn-mt bug 2445206
	rm man/inadyn.8 man/inadyn.conf.5 || die
	# end workaround

	doman man/* || die

	dohtml readme.html || die

	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die

	insinto /etc
	doins "${FILESDIR}"/${PN}.conf || die

}

pkg_postinst() {
	elog "You will need to edit /etc/inadyn-mt.conf before running inadyn-mt"
	elog "for the first time. The format is basically the same as the"
	elog "command line options; see inadyn-mt and inadyn-mt.conf manpages."
}
