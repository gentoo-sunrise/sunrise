# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils versionator

KEYWORDS="~x86"

MY_P=${P/pya/PyA}

DESCRIPTION="Python wrapper for the Amanith 2D vector graphics library"
HOMEPAGE="http://louhi.kempele.fi/~skyostil/projects/pyamanith/"
SRC_URI="http://louhi.kempele.fi/~skyostil/projects/${PN}/dist/${MY_P}.tar.gz"
LICENSE="QPL"
SLOT="0"
IUSE=""

RDEPEND="=media-libs/amanith-$(get_version_component_range 1-2)*
		media-libs/glew"
DEPEND="${RDEPEND}
		>=dev-lang/swig-1.3.29"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-setup_py.patch"
	epatch "${FILESDIR}/${P}-gdrawboard.patch"
}
