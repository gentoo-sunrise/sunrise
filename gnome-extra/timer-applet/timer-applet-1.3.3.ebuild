# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 flag-o-matic

DESCRIPTION="A countdown timer applet for the GNOME panel"
HOMEPAGE="http://timerapplet.sourceforge.net"
SRC_URI="mirror://sourceforge/timerapplet/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc sounds libnotify"

DEPEND=">=gnome-base/gnome-panel-2.6
	>=x11-libs/gtk+-2.8
	dev-libs/libxml2
	sounds? ( gnome-extra/gnome-audio )
	libnotify? ( >=x11-libs/libnotify-0.3 )"
RDEPEND="${DEPEND}"

DOCS="AUTHORS Changelog NEWS README"

src_compile() {
	append-flags $(xml2-config --cflags)
	gnome2_src_compile
}
