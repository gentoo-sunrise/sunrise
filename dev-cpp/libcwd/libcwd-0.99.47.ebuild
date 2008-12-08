# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A library to support C++ developers with debugging their applications"
HOMEPAGE="http://libcwd.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="QPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples pch"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e 's/-O3//' \
		configure || die "sed failed"

	epatch "${FILESDIR}"/gcc-4.3.patch ||die

	# Clean-out possibly old docs
	rm -f  documentation/doxygen.config
	rm -rf documentation/html/*
}

src_compile() {
	econf \
		$(use_enable pch) \
		$(use_enable debug) \
		|| die "econf failed"
	emake || die "emake failed"

	if use doc; then
		cd documentation
		doxygen doxygen.config
	fi
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"

	dodoc README* NEWS

	if use doc; then
		dohtml -r documentation/reference-manual/*
		insinto /usr/share/doc/${PF}
		doins -r documentation/tutorial
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r example-project
	fi
}
