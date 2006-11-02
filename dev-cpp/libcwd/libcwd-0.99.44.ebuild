# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Libcwd is a library to support C++ developers with debugging their applications"
HOMEPAGE="http://libcwd.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="QPL"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Clean-out possibly old docs
	rm -f  documentation/doxygen.config
	rm -rf documentation/html/*
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"

	if use doc; then
		cd documentation
		doxygen doxygen.config
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc README* NEWS

	if use doc; then
		dohtml -r documentation/reference-manual/*
		insinto /usr/share/${PN}
		doins -r documentation/tutorial
	fi

	if use examples; then
		insinto /usr/share/${PN}
		doins -r example-project
	fi
}
