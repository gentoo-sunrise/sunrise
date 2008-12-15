# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit libtool eutils

DESCRIPTION="This C++ library provides the basic methods for Non-Uniform Rational B-Splines (NURBS)."
HOMEPAGE="http://libnurbs.sourceforge.net/"
SRC_URI="mirror://sourceforge/libnurbs/${P}.tar.bz2
	http://dev.gentooexperimental.org/~jokey/sunrise-dist/${P}-gcc-4.1.patch.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-lang/perl"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${P}-gcc-4.1.patch
	epatch "${FILESDIR}"/${P}-gcc-4.3.patch
	elibtoolize
}

src_compile() {
	econf \
		--without-x \
		$(use_enable debug) \
		$(use_enable debug verbose-exception) \

	emake || die "emake failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed!"
	dodoc AUTHORS ChangeLog NEWS README
}
