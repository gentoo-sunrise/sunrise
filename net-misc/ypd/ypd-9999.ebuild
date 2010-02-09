# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="split tcp requests of different type to different servers"
HOMEPAGE="http://ypd.berlios.de/"
SRC_URI=""
EGIT_REPO_URI="git://repo.or.cz/ypd.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dobin src/ypd || die "dobin failed"
	newinitd "${FILESDIR}/ypd.rc" ypd || die "newinitd failed"
	newconfd "${FILESDIR}/ypd.conf" ypd || die "newconfd failed"
	dodoc README ChangeLog AUTHORS || die "dodoc failed"
}
