# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools games

MY_MUSIC="${PN}-music-1.0.run"

DESCRIPTION="3D OpenGL moderately-strong chess engine"
HOMEPAGE="http://www.dreamchess.org/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz
	sound? ( music? ( mirror://berlios/${PN}/${MY_MUSIC}.tar ) )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="music sound"

RDEPEND="virtual/opengl
	media-libs/libsdl
	media-libs/sdl-image
	sound? ( media-libs/sdl-mixer )
	dev-libs/mini-xml"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-configure.ac.patch"
	eautoreconf
	if use music ; then
		if use sound ; then
			"${WORKDIR}/${MY_MUSIC}" --tar xf
		else
			ewarn "You need to enable the sound use flag to play music."
		fi
	fi
}

src_compile() {
	egamesconf $( use_with sound mixer-sdl )
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
	newicon data/icon.png ${PN}.png || die "newicon failed"
	make_desktop_entry ${PN} "DreamChess" ${PN}.png
	prepgamesdirs
}

