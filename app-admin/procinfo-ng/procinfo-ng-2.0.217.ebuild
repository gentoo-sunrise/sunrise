# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Completely rewrite of the old system monitoring app procinfo."
HOMEPAGE="http://sourceforge.net/projects/procinfo-ng/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="|| ( GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="sys-libs/ncurses"

RDEPEND="${DEPEND}
	!app-admin/procinfo"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-as-needed.patch
	# removing -s flag as portage does the stripping part and add support
	# for custom LDFLAGS. Plus correct for --as-needed
	sed -e 's:-s -lncurses:${LDFLAGS}:' \
		-i configure.in || die "sed configure.in failed"
	eautoreconf
}

src_compile() {
	econf
	emake LIBS="-lncurses" || die "compile failed"
}

src_install() {
	emake install DESTDIR="${D}" || "install failed"
}

