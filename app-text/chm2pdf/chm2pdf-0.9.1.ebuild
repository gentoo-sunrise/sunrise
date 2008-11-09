# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A script that converts a CHM file into a single PDF file."
HOMEPAGE="http://code.google.com/p/${PN}/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
RDEPEND="dev-python/pychm
	app-text/htmldoc
	dev-libs/chmlib
	dev-lang/python"

src_install() {
	dobin ${PN} || die "failed to create executable"
	dodoc README
}
