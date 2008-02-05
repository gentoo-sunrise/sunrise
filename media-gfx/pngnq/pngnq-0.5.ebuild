# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Pngnq is a tool for quantizing PNG images in RGBA format."
HOMEPAGE="http://www.cybertherial.com/pngnq/pngnq.html"
SRC_URI="http://www.cybertherial.com/pngnq/${P}-src.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-libs/libpng"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Patch makefile to work around sandbox violations
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_install() {
	emake install DESTDIR="${D}" || die "install failed"
}
