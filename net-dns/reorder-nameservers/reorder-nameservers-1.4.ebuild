# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Shell script that reorders nameserver entries if the primary nameserver is down"
HOMEPAGE="http://reorder-ns.sourceforge.net/"
SRC_URI="mirror://sourceforge/reorder-ns/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="net-analyzer/nmap
	sys-apps/ifplugd"

src_install() {
	dosbin ${PN} || die "missing ${PN}"
	doman ${PN}.8 || die "missing ${PN}.8"
	dodoc TODO || die "missing TODO"
	insinto /etc/logrotate.d
	newins ${PN}.logrotate ${PN} || die "missing ${PN}.logrotate"
}