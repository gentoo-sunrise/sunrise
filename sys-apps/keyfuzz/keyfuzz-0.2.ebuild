# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Utility for manipulating the scancode/keycode translation tables of
keyboard drivers"
HOMEPAGE="http://0pointer.de/lennart/projects/keyfuzz/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="doc? ( www-client/lynx )"
RDEPEND=""

src_compile() {
	econf $(use_enable doc lynx) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin src/keyfuzz
	use doc && dodoc README
	doman man/*
}
