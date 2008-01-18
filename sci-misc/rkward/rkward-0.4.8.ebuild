# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ARTS_REQUIRED="never"
inherit kde

DESCRIPTION="An IDE/GUI for the R-project"
HOMEPAGE="http://rkward.sourceforge.net/"
SRC_URI="mirror://sourceforge/rkward/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lang/R
	dev-lang/php"
RDEPEND="${DEPEND}"

src_install() {
	kde_src_install
	rm "${D}/usr/lib/R/library/R.css"
	mv "${D}/share" "${D}/usr/"
}
