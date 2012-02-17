# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnome2

DESCRIPTION="A weather monitoring program"
HOMEPAGE="http://lug.rose-hulman.edu/proj/aweather"
SRC_URI="http://lug.rose-hulman.edu/proj/${PN}/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="gps"

RDEPEND="=sci-libs/grits-${PV}
	x11-libs/gtk+:2
	sci-libs/rsl
	gps? ( >=sci-geosciences/gpsd-3 )"
DEPEND="${RDEPEND}"

DOCS="ChangeLog README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable gps)"
}
