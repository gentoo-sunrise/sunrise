# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

DESCRIPTION="Open Source ERP & CRM client"
HOMEPAGE="http://tinyerp.org/"
SRC_URI="${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="fetch"

DEPEND=">=dev-lang/python-2.3
	>=dev-python/pygtk-2.6"
RDEPEND=${DEPEND}

DOWNLOAD_URL="http://tinyerp.com/component/option,com_vfm/Itemid,61/do,download/file,stable|source|i${P}.tar.gz/"
pkg_nofetch() {
	einfo "Please donwload ${SRC_URI} from:"
	einfo ${DOWNLOAD_URL}
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-setup.patch"
	epatch "${FILESDIR}/${P}-options.patch"
}

src_install() {
	distutils_src_install

	keepdir /usr/share/${PN}/themes
}
