# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_P=${P/-/}_src

DESCRIPTION="A game in the genre of Rogue, Nethack, and Diablo. Emphasis is on tactical play."
HOMEPAGE="http://www.zincland.com/powder/"
SRC_URI="http://www.zincland.com/${PN}/release/${MY_P}.tar.gz"

LICENSE="powder_license"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/libsdl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-make.patch"
}

src_compile() {
	cd port/linux
	CXXFLAGS="${CXXFLAGS} -DCHANGE_WORK_DIRECTORY" emake || die
}

src_install() {
	dogamesbin port/linux/${PN} || die "dogamesbin failed"
	dodoc README.TXT CREDITS.TXT || die "dodoc failed"
	prepgamesdirs
}
