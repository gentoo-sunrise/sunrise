# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit gnome2

DESCRIPTION="Nautilus extension for adding user-configurable actions to the context menu"
HOMEPAGE="http://www.grumz.net/?q=taxonomy/term/2/9"
SRC_URI="ftp://ftp2.grumz.net/grumz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	gnome-base/libglade:2.0
	gnome-base/libgnome
	gnome-base/libgnomeui
	gnome-base/gconf:2
	dev-libs/libxml2
	gnome-base/nautilus"
DEPEND=">=dev-util/intltool-0.29
	>=dev-util/pkgconfig-0.9.0
	${RDEPEND}"

DOCS="AUTHORS ChangeLog MAINTAINERS README TODO"
