# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Karaoke player for Linux"
HOMEPAGE="http://www.kibosh.org/pykaraoke/index.php"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/pygame-1.6.2
	>=dev-python/wxpython-2.6.1.0
	>=dev-python/numeric-23.7
	>=x11-libs/wxGTK-2.6.2-r1
	>=media-libs/libsdl-1.2.8-r1"

src_install() {
	distutils_src_install
}
