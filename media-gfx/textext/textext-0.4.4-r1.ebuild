# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Inkscape extension to embed re-editable LaTeX objects in SVG drawings"
HOMEPAGE="http://pav.iki.fi/software/textext/"
SRC_URI="http://pav.iki.fi/software/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="media-gfx/inkscape
	virtual/latex-base
	|| ( media-gfx/pdf2svg media-gfx/pstoedit[plotutils] )"

src_prepare() {
	# Patch from upstream
	# http://bitbucket.org/pv/textext/changeset/2a376a0465a4
	epatch "${FILESDIR}/${P}-md5-to-hashlib.patch"
}

src_install() {
	exeinto /usr/share/inkscape/extensions
	doexe *.py || die "doexe failed. Can't copy script to extensions folder"

	insinto /usr/share/inkscape/extensions
	doins *.inx || die "doins faild. Can't copy script to extensions folder"
}
