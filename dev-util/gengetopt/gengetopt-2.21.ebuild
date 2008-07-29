# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="a tool to write option parsing code for C programs."
HOMEPAGE="http://www.gnu.org/software/gengetopt/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

src_install() {
	cd src
	emake DESTDIR="${D}" install || die "emake install failed"

	cd "${S}"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	cd doc
	dohtml *.html
	doinfo *.info
	doman *.1
	if use examples; then
		docinto examples
		dodoc sample{1,2}.ggo main{1.cc,2.c} cmdline{1,2}.{c,h} README.example
	fi
}
