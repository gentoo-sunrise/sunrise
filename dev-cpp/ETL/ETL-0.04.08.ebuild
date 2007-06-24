# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="1.6"
inherit autotools

DESCRIPTION="VoriaETL is a multiplatform class and template library designed to complement and supplement the C++ STL."
HOMEPAGE="http://www.synfig.com/"
SRC_URI="http://www.bridgetone.com/voria/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
DEPEND="doc? ( app-doc/doxygen )"


src_compile() {
	./bootstrap || die 'Bootstrap failed.'
	econf || die 'Configure failed.'
	emake || die 'Make failed.'
	if use doc; then 
		emake docs || die "make docs failed."
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die 'Install failed!'
	if use doc; then
		dohtml doc/html/*
	fi
}
