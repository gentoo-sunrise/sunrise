# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PV=${PV/_/-}

DESCRIPTION="Multicast Routing Daemon using only IGMP signalling (Internet Group Management Protocol)"
HOMEPAGE="http://sourceforge.net/projects/igmpproxy"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}/src

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-remove-banner.patch"
}

src_compile() {
	# >-j1 may fail 
	emake -j1 || die "emake failed"
}

src_install() {
	dobin igmpproxy || die

	insinto /etc
	doins igmpproxy.conf || die

	newinitd "${FILESDIR}"/igmpproxy-init.d igmpproxy || die
	newconfd "${FILESDIR}"/igmpproxy-conf.d igmpproxy || die

	doman ../doc/igmpproxy.8 || die
	doman ../doc/igmpproxy.conf.5 || die
}

pkg_postinst() {
	elog "As IGMPproxy is logging much directly to syslog,"
	elog "you should consider filtering to a separate file or drop it."
}
