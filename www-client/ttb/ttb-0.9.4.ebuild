# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.4"

inherit eutils python distutils

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
