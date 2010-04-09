# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="C library for quantum computing and quantum simulation"
HOMEPAGE="http://www.libquantum.de/"
SRC_URI="http://www.libquantum.de/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="+lapack examples profile"

DEPEND="lapack? ( virtual/lapack )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_with lapack) \
		$(use_enable profile profiling)
}

src_compile() {
	emake || die
	emake quobtools || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	emake DESTDIR="${D}" quobtools_install || die
	dodoc CHANGES || die
	if use examples ; then
		docinto examples/
		newdoc INSTALL INSTALL.how_to_compile_own_stuff || die
		dodoc shor.c grover.c || die
	fi
}
