# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils

DESCRIPTION="pdf2svg is based on poppler and cairo and can convert pdf to svg files"
HOMEPAGE="http://www.cityinthesky.co.uk/${PN}.html"
SRC_URI="http://www.cityinthesky.co.uk/files/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-text/poppler
	x11-libs/cairo"
DEPEND="${RDEPEND}"

pkg_setup() {
	if ! built_with_use x11-libs/cairo svg ; then
		eerror "you need to emerge x11-libs/cairo with svg support."
		die "remerge x11-libs/cairo with USE=\"svg\""
	fi
}

src_install() {
	dobin ${PN}
}
