# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit base toolchain-funcs

DESCRIPTION="A tool for resizing BDF format fonts"
HOMEPAGE="http://openlab.jp/efont/dist/tools/bdfresize/"
SRC_URI="http://openlab.jp/efont/dist/tools/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-gcc4.0.patch" )

src_compile() {
	emake CC="$(tc-getCC)"
}
