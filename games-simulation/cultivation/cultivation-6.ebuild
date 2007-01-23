# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games eutils toolchain-funcs flag-o-matic

MY_PN=Cultivation

DESCRIPTION="a game about a community of gardeners growing food for themselves
in a shared space"
HOMEPAGE="http://cultivation.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}_${PV}_UnixSource.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glut
	media-libs/mesa
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXmu"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_PN}_${PV}_UnixSource

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-compile.patch"
}

src_compile() {
	cd "${S}"/game2
	# don't use econf as it is not an autotools configure
	./configure

	cd "${S}"/minorGems/sound/portaudio
	chmod u+x configure
	econf || die "econf failed"
	emake || die "emake failed"

	cd "${S}"/game2/gameSource
	emake GXX="$(tc-getCXX)" || die "emake failed"
}

src_install() {
	dogamesbin game2/gameSource/Cultivation
	dodoc game2/{documentation/how_to_*.txt,gameSource/features.txt}
}
