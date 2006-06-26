# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Detects CD/DVD types without mounting them"
HOMEPAGE="http://www.bellut.net/projects.html#cddetect"
SRC_URI="http://www.bellut.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e '1,2d' Makefile || die "sed failed"
}

src_install() {
	dobin ${PN} || die "dobin failed"
}
