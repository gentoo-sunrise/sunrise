# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Gnome frontend to Anyremote"
HOMEPAGE="http://anyremote.sourceforge.net/"
SRC_URI="mirror://sourceforge/anyremote/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth"

DEPEND=" net-misc/anyremote[bluetooth=]
	dev-python/pygtk
	dev-python/pybluez "
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	make_desktop_entry ${PN} ${PN} ${PN}.png "Network;RemoteAccess"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
