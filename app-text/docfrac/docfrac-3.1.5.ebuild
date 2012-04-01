# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="rtf/html/text conversion utility"
HOMEPAGE="http://docfrac.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	sed -i \
		-e "/CPPFLAGS=/s:-.*::" \
		-e "s:ar -:$(tc-getAR) -:" \
		-e "s:g++ -:$(tc-getCXX) -:g" \
		Makefile || die "sed failed in Makefile"

	epatch "${FILESDIR}"/${PV}-gcc46.patch
}

src_compile() {
	emake ${PN}
}

src_install() {
	# manual install because Makefile doesn't respect DESTDIR
	dobin ${PN}
	doman doc/${PN}.1
}
