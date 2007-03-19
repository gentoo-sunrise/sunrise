# Copyright 2007-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="a set of tools for updating gentoo config files"
HOMEPAGE="http://michaelsen.kicks-ass.net/Members/bjoern/etcproposals/"
SRC_URI="http://michaelsen.kicks-ass.net/Members/bjoern/etcproposals/downloads/${P}.tar.gz"

IUSE="gtk"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="gtk? ( >=dev-python/pygtk-2.10 )"
RDEPEND="${DEPEND}"

src_install(){
	distutils_src_install
	dodir /usr/sbin
	dosbin "${D}"/usr/bin/etc-proposals
	rm -rf "${D}"/usr/{bin,share}
}

pkg_postinst() {
	einfo "The configuration file has been installed to /etc/etc-proposals.conf"
	ewarn "A full backup of /etc and other files managed by CONFIG_PROTECT"
	ewarn "is highly advised before testing this tool!"
}
