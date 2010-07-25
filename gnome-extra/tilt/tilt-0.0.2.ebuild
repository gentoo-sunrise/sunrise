# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="HDAPS visualization as Gnome applet"
HOMEPAGE="http://sourceforge.net/projects/hdaps/files/gnome-tilt/"
SRC_URI="mirror://sourceforge/hdaps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="gnome-base/gconf:2
	gnome-base/libgnomeui
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	dobin src/${PN} || die
	make_desktop_entry ${PN} Tilt ${PN} System
	dodoc AUTHORS || die
}
