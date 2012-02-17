# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EGIT_REPO_URI="git://lug.rose-hulman.edu/proj/aweather"
EGIT_BOOTSTRAP="eautoreconf"

EAPI=4
inherit autotools gnome2 git-2

DESCRIPTION="A weather monitoring program"
HOMEPAGE="http://lug.rose-hulman.edu/proj/aweather"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="gps"

RDEPEND="~sci-libs/grits-9999
	x11-libs/gtk+:2
	sci-libs/rsl
	gps? ( >=sci-geosciences/gpsd-3 )"
DEPEND="${RDEPEND}"

DOCS="ChangeLog README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable gps)"
}
