# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GCONF_DEBUG="no"
SCROLLKEEPER_UPDATE="no"

inherit gnome2

DESCRIPTION="Time tracking for the masses, in a GNOME applet"
HOMEPAGE="http://live.gnome.org/ProjectHamster"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.5
	>=dev-python/gnome-python-2.10
	>=dev-python/pygobject-2.6
	>=dev-python/pygtk-2.6
	=dev-python/pysqlite-2*
	x11-libs/libXScrnSaver"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.37.1
	dev-util/pkgconfig
	sys-devel/gettext"

DOCS="AUTHORS ChangeLog NEWS README"
