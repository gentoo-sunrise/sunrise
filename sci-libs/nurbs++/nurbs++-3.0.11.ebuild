# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

DESCRIPTION="Non Uniform Rational Basis Spline (NURBS) library for C++"
HOMEPAGE="http://libnurbs.sourceforge.net/index.shtml"
SRC_URI="mirror://sourceforge/libnurbs/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

DEPEND="dev-lang/perl
	doc? ( app-doc/doxygen ) "
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc-4.3.patch.bz2
	epatch "${FILESDIR}"/${P}-gcc-4.4.patch
	epatch "${FILESDIR}"/${P}-linker.patch
	eautoreconf
}

src_configure() {
	econf \
		--without-x \
		$(use_enable debug) \
		$(use_enable debug verbose-exception)
}

src_compile() {
	emake || die 'emake failed'
	if use doc ; then
		doxygen || die 'doxygen failed'
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed!"
	dodoc AUTHORS ChangeLog README
	use doc && dohtml -r html/*
}
