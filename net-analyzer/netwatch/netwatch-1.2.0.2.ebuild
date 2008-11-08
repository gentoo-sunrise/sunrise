# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_PV=$(replace_version_separator 3 '-')

DESCRIPTION="Ethernet/PPP IP Packet Monitor"
HOMEPAGE="http://www.slctech.org/~mackay/netwatch.html"
SRC_URI="http://www.slctech.org/~mackay/NETWATCH/${PN}-${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"

S=${WORKDIR}/${PN}-$(get_version_component_range 1-3)

src_install() {
	dobin netresolv netwatch || die "dobin failed"

	doman netwatch.1 || die "doman failed"
	dodoc BUGS CHANGES README* TODO || die "dodoc failed"

	if use doc; then
		dohtml NetwatchKeyCommands.html || die "dohtml failed"
	fi
}

