# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-info

DESCRIPTION="the low-level library for netfilter related kernel/userspace communication"
HOMEPAGE="http://www.netfilter.org/projects/libnfnetlink/"
SRC_URI="http://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

CONFIG_CHECK="NETFILTER_NETLINK"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is lt 2 6 14 && die "requires at least 2.6.14 kernel version"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
