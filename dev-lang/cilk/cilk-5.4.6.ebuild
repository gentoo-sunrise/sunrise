# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

DESCRIPTION="Language for multithreaded parallel programming based on ANSI C."
HOMEPAGE="http://supertech.csail.mit.edu/${PN}/"
SRC_URI="http://supertech.csail.mit.edu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

src_compile() {
	# cilk compiler doesn't like this flags...
	filter-flags "-pipe"
	filter-flags "-ggdb"

	econf
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc NEWS README THANKS

	use doc && dodoc doc/manual.pdf

	if use examples; then
		docinto examples
		dodoc examples/*.{cilk,c,h}
	fi
}
