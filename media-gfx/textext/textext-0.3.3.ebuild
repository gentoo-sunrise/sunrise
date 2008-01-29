# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils

DESCRIPTION="textext is an inkscape extension, which embed re-editable LaTeX objects in SVG drawings"
HOMEPAGE="http://www.elisanet.fi/ptvirtan/software/${PN}/"
SRC_URI="http://www.elisanet.fi/ptvirtan/software/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( media-gfx/pdf2svg media-gfx/pstoedit )"
DEPEND="${RDEPEND}"

pkg_setup() {
	if ! has_version media-gfx/pdf2svg && ! built_with_use media-gfx/pstoedit plotutils ; then
		eerror "you need to emerge eihter media-gfx/pstoedit with plotutils support or media-gfx/pdf2svg."
		die "Either remerge media-gfx/pstoedit with USE=\"plotutils\" or emerge media-gfx/pdf2svg"
	fi
}

src_install() {
	insinto /usr/share/inkscape/extensions
	insopts -m0755
	doins *.py

	insopts -m0644
	doins *.inx
}
