# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
inherit gnome2

DESCRIPTION="Virtual Globe library"
HOMEPAGE="http://lug.rose-hulman.edu/wiki/Libgis"
SRC_URI="http://lug.rose-hulman.edu/proj/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug doc"

RDEPEND=">=net-libs/libsoup-2.26
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/gtkglext"
DEPEND="${RDEPEND}"

DOCS="ChangeLog README TODO"
