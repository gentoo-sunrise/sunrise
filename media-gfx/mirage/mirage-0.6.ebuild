# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="A fast and simple GTK+ image viewer."
HOMEPAGE="http://mirageiv.berlios.de/"
SRC_URI="http://download.berlios.de/mirageiv/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/pygtk-2.6"
