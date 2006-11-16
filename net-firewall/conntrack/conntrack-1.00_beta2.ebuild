# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-info

MY_P="${P/_}"

DESCRIPTION="view and manage the in-kernel connection tracking state table"
HOMEPAGE="http://www.netfilter.org/projects/conntrack/"
SRC_URI="http://www.netfilter.org/projects/${PN}/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="net-libs/libnfnetlink
	net-libs/libnetfilter_conntrack"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

CONFIG_CHECK="IP_NF_CONNTRACK_NETLINK"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is lt 2 6 14 && die "${PN} requires at least 2.6.14 kernel version"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog
}
