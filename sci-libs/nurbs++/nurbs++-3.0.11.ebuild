# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit libtool eutils

DESCRIPTION="NURBS library for cpp"
HOMEPAGE="http://libnurbs.sourceforge.net/"
SRC_URI="mirror://sourceforge/libnurbs/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X debug" #opengl

DEPEND="dev-lang/perl
	X? ( x11-base/xorg-x11 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/nurbs++-3.0.11-gcc-4.1.patch
	elibtoolize
}

src_compile() {
	econf \
		$(use_with X x) \
		--prefix=/usr \
		$(use_enable debug) \
		$(use_enable debug verbose-exception) \
		|| die "Error: econf failed!"
	emake || die "Error: emake failed!"
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README
}
