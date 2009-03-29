# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools linux-info

DESCRIPTION="Multicast Routing Daemon using only IGMP signalling (Internet Group Management Protocol)"
HOMEPAGE="http://sourceforge.net/projects/igmpproxy"
SRC_URI="http://dev.gentooexperimental.org/~idl0r/distfiles/${P}.tar.bz2"

LICENSE="GPL-2 Stanford"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CONFIG_CHECK="IP_MULTICAST IP_MROUTE"

src_prepare() {
	# create necessary files
	eautoreconf
}

src_configure() {
	# igmpproxy requires to be root
	econf --bindir=/usr/sbin
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}"/igmpproxy-init.d igmpproxy || die
}

pkg_postinst() {
	elog "As IGMPproxy is logging much directly to syslog,"
	elog "you should consider filtering to a separate file or drop it."
}
