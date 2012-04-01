# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils distutils

DESCRIPTION="TeleText Browser for Dutch teletext pages from NOS"
HOMEPAGE="http://www.djcbsoftware.nl/code/ttb/"
SRC_URI="http://www.djcbsoftware.nl/code/ttb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-nodisplay.patch"
}
