# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit gnome2

DESCRIPTION="Graphical user interface for smartctl"
HOMEPAGE="http://gsmartcontrol.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4
	dev-libs/libpcre
	sys-apps/smartmontools"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS.txt ChangeLog NEWS README.txt"
