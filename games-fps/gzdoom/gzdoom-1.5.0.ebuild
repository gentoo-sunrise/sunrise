# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games cmake-utils

DESCRIPTION="Enhanced OpenGL port of the official DOOM source code that also supports Heretic, Hexen, and Strife"
HOMEPAGE="http://grafzahl.drdteam.org/"
SRC_URI="http://omploader.org/vNWJoMQ/${P}.tar.bz2"

LICENSE="DOOMLIC BUILDLIC BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mmx gtk"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	media-libs/flac
	media-libs/fmod:1
	media-libs/jpeg
	media-libs/libsdl"

DEPEND="${REPEND}
	mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )"

src_prepare() {
	# Use default game data path"
	sed -i \
		-e "s:/usr/local/share/:${GAMES_DATADIR}/doom-data/:" \
		src/sdl/i_system.h || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_no mmx ASM)
		$(cmake-utils_use_no gtk GTK)
	)

	cmake-utils_src_configure
}

src_install() {
	dodoc docs/*.{txt,TXT} || die
	dohtml docs/console*.{css,html} || die

	cd "${CMAKE_BUILD_DIR}" || die
	dogamesbin ${PN} || die

	insinto "${GAMES_DATADIR}/doom-data"
	doins ${PN}.pk3 || die

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Copy or link wad files into ${GAMES_DATADIR}/doom-data/"
	elog "(the files must be readable by the 'games' group)."
	elog
	elog "To play, simply run:"
	elog "   gzdoom"
	elog
	elog "See /usr/share/doc/${P}/zdoom.txt.bz2 for more info"
}
