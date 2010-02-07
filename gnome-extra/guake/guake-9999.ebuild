# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit autotools gnome2 git

DESCRIPTION="Guake is a drop-down terminal for Gnome"
HOMEPAGE="http://guake.org/"
EGIT_REPO_URI="git://git.guake.org/guake.git"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="virtual/python
	dev-python/dbus-python
	dev-python/gnome-python
	dev-python/notify-python
	x11-libs/vte[python]"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	dev-util/pkgconfig"

src_prepare() {
	intltoolize -c -f --automake || die "intltoolize failed"
	gnome2_omf_fix
	AT_M4DIR="m4" eautoreconf
}
