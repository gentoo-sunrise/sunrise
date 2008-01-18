# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Detects CD/DVD types without mounting them"
HOMEPAGE="http://www.bellut.net/projects.html#cddetect"
SRC_URI="http://www.bellut.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e '2d' \
		-e "s:gcc:$(tc-getCC):" Makefile \
		|| die "sed failed in Makefile"
}

src_install() {
	dobin ${PN}
}
