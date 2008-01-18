# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON="2.2.0"
inherit eutils distutils

DESCRIPTION="TeleText Browser for Dutch teletext pages from NOS"
HOMEPAGE="http://www.djcbsoftware.nl/code/ttb/"
SRC_URI="http://www.djcbsoftware.nl/code/ttb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-python/pygtk"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-nodisplay.patch"
}
