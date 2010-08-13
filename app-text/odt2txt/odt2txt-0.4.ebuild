# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="A simple converter from OpenDocument Text to plain text"
HOMEPAGE="http://stosberg.net/odt2txt/"
SRC_URI="http://stosberg.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE=""

RDEPEND="sys-libs/zlib
	virtual/libiconv"
DEPEND="sys-apps/groff
	$RDEPEND"

src_prepare() {
	epatch "${FILESDIR}"/${P}-darwin_iconv.patch
}

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr || die
	doman odt2txt.1 || die
}
