# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="KDE frontend to Anyremote"
HOMEPAGE="http://anyremote.sourceforge.net/"
SRC_URI="mirror://sourceforge/anyremote/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=" >=net-misc/anyremote-4.4
	 >=dev-python/PyQt-3.17
	 >=dev-python/pykde-3.16"

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	make_desktop_entry ${PN} ${PN} ${PN}.png "Network;RemoteAccess"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}

pkg_postinst() {
	if ! built_with_use net-misc/anyremote bluetooth ; then
		elog
		elog "If you want to use bluetooth with kanyremote, you need to"
		elog "compile net-misc/anyremote with bluetooth use flag."
	fi
}

