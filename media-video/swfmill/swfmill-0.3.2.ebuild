# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="xml2swf and swf2xml processor with import functionalities"
HOMEPAGE="http://swfmill.org"
SRC_URI="http://swfmill.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# until media-video/mtasc is fixed
RESTRICT="test"

RDEPEND="dev-libs/libxml2
	dev-libs/libxslt
	media-libs/freetype:2
	media-libs/libpng:0
	sys-libs/zlib"

DEPEND="${RDEPEND}
	sys-devel/libtool
	virtual/pkgconfig"

# until parallel compilation is fixed upstream
# https://github.com/djcsdy/swfmill/issues/21
src_compile() { 
	emake -j1 
}


