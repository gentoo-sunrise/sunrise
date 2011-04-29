# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Graphical front-end to various Development tools such as gcc"
HOMEPAGE="http://www.openldev.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""
LICENSE="GPL-2"

S=${WORKDIR}/${PN}

DEPEND="x11-libs/gtk+:2
		x11-libs/gtksourceview:1.0
		gnome-base/gnome-vfs:2
		x11-libs/vte:0
		gnome-base/libglade:2.0
		dev-libs/libxml2
		gnome-base/libgnomeprint:2.2
		gnome-base/libgnomeprintui:2.2
		gnome-base/gconf:2
		>=gnome-base/libgnomeui-2.0
		x11-terms/gnome-terminal"
RDEPEND="${DEPEND}"
