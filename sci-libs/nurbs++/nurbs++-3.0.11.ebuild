# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit libtool eutils

DESCRIPTION="NURBS library for cpp"
HOMEPAGE="http://libnurbs.sourceforge.net/"
SRC_URI="mirror://sourceforge/libnurbs/${P}.tar.bz2"
#           mirror://sourceforge/${P}-gcc-4.1.patch" # can't get that patch directly from SF.net

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X debug" #opengl

DEPEND="dev-lang/perl
	X? ( x11-base/xorg-x11 )"
	#media-gfx/imagemagick # doesn't work yet either
	# opengl? ( virtual/opengl ) # doesn't work yet

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/nurbs++-3.0.11-gcc-4.1.patch
	elibtoolize
}

src_compile() {
	local myconf=""
	#use opengl \
	#	&& myconf="${myconf} --with-opengl=/usr" \
	#	|| myconf="${myconf} --without-opengl"

	if use X ; then
		myconf="${myconf} --with-x"
	else
		myconf="${myconf} --without-x"
	fi

	./configure \
		${myconf} \
		--prefix=/usr \
		`use_enable debug` \
		`use_enable debug verbose-exception` \
		|| die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README
}
