# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
inherit gnome2

DESCRIPTION="A weather monitoring program"
HOMEPAGE="http://lug.rose-hulman.edu/wiki/AWeather"
SRC_URI="http://lug.rose-hulman.edu/proj/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

RDEPEND="=sci-libs/libgis-${PV}
	x11-libs/gtk+:2
	sci-libs/rsl"
DEPEND="${RDEPEND}"

DOCS="ChangeLog README TODO"
