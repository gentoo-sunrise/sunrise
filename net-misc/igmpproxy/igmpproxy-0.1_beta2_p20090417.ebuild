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
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

CONFIG_CHECK="IP_MULTICAST IP_MROUTE"

src_prepare() {
	# Create necessary files.
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}"/igmpproxy-init.d ${PN} || die
	newconfd "${FILESDIR}"/igmpproxy-conf.d ${PN} || die
}
