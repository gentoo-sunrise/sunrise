# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="display the current traffic on all network devices"
HOMEPAGE="http://www.isotton.com/software/unix/cbm/"
SRC_URI="http://www.isotton.com/software/unix/${PN}/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	app-text/xmlto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/gcc-4.3.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
