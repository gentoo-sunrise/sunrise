# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Gnome frontend to Anyremote"
HOMEPAGE="http://anyremote.sourceforge.net/"
SRC_URI="mirror://sourceforge/anyremote/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=" net-misc/anyremote
	dev-python/pygtk
	dev-python/pybluez "
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	make_desktop_entry ${PN} ${PN} ${PN}.png "Network;RemoteAccess"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}

pkg_postinst() {
	if ! built_with_use net-misc/anyremote bluetooth ; then
		ewarn "If you want to use bluetooth with ganyremote, you need to "
		ewarn "compile net-misc/anyremote with bluetooth use flag."
	fi
}
