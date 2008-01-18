# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON="2.4"

inherit gnome2 python

DESCRIPTION="Simple, slim, sleek, yet powerful text editor for GNOME"
HOMEPAGE="http://scribes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.10
	>=gnome-base/gconf-2.12.0
	>=dev-python/dbus-python-0.71
	>=dev-python/pygtk-2.10.0
	>=dev-python/gnome-python-2.12.0
	>=dev-python/gnome-python-desktop-2.12.0
	>=dev-python/gnome-python-extras-2.12.0
	>=gnome-extra/yelp-2.12.0"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/intltool-0.35"

DOCS="AUTHORS README ChangeLog NEWS"
