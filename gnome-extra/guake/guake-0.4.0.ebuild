# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit gnome2

DESCRIPTION="Guake is a drop-down terminal for Gnome"
HOMEPAGE="http://guake.org/"
SRC_URI="http://guake.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/python
	dev-python/gnome-python
	dev-python/notify-python
	x11-libs/vte[python]
	dev-python/dbus-python"
RDEPEND=${DEPEND}
