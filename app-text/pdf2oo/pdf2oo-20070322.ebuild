# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Converts pdf files to odf"
HOMEPAGE="http://sourceforge.net/projects/pdf2oo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="kde"

DEPEND=""
RDEPEND=">=app-text/poppler-0.5.3
	>=media-gfx/imagemagick-6.2.8.0
	>=app-arch/zip-2.31
	kde? (
		|| (
			( >=kde-base/kdialog-3.5.0 >=kde-base/kommander-3.5.2 )
			kde-base/kdebase
		)
		>=kde-base/kdelibs-3.5.2-r6 )"

S="${WORKDIR}/${PN}"

src_install() {
	dobin pdf2oo
	dodoc README
}
