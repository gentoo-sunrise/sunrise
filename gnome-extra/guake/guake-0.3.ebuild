# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit gnome2 versionator
B=$(get_version_component_range 1-2)

DESCRIPTION="Guake is a drop-down terminal for Gnome"
HOMEPAGE="http://guake-terminal.org/"
SRC_URI="http://guake-terminal.org/releases/${B}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	x11-libs/gtk+:2
	gnome-base/gconf:2
	x11-libs/libX11
	dev-python/notify-python
	x11-libs/vte"
