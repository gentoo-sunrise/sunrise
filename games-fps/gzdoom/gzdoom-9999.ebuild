# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games cmake-utils subversion eutils

DESCRIPTION="Enhanced OpenGL port of the official DOOM source code that also supports Heretic, Hexen, and Strife"
HOMEPAGE="http://www.osnanet.de/c.oelckers/gzdoom/index.html"
ESVN_REPO_URI="http://mancubus.net/svn/hosted/gzdoom/trunk/"

LICENSE="DOOMLIC BUILDLIC BSD"
SLOT="0"
KEYWORDS=""
IUSE="mmx gtk fluidsynth"

RDEPEND="
	fluidsynth? ( media-sound/fluidsynth )
	gtk? ( x11-libs/gtk+:2 )
	media-libs/flac
	media-libs/fmod:1
	virtual/glu
	virtual/jpeg
	virtual/opengl
	media-libs/libsdl"

DEPEND="${RDEPEND}
	mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )"

src_prepare() {
	# Use default game data path
	sed -i \
		-e "s:/usr/local/share/:${GAMES_DATADIR}/doom-data/:" \
		src/sdl/i_system.h || die
	epatch "${FILESDIR}/${PN}-respect-fluidsynth-useflag.patch"
#	epatch "${FILESDIR}/${P}-fix-new-fmod.patch"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_no mmx ASM)
		$(cmake-utils_use_no gtk GTK)
		$(cmake-utils_use_use fluidsynth FLUIDSYNTH)
		-DFMOD_INCLUDE_DIR=/opt/fmodex/api/inc/
		-DFMOD_LIBRARY=/opt/fmodex/api/lib/libfmodex.so
	)

	cmake-utils_src_configure
}

src_install() {
	dodoc docs/*.{txt,TXT}
	dohtml docs/console*.{css,html}

	cd "${CMAKE_BUILD_DIR}" || die
	dogamesbin ${PN} || die

	insinto "${GAMES_DATADIR}/doom-data"
	doins ${PN}.pk3

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
	if use fluidsynth && ! has_version media-sound/fluid-soundfont; then
		ewarn "You may need to install media-sound/fluid-soundfont"
		ewarn "for fluidsynth to play music, depending on your sound card."
	fi
	elog "See /usr/share/doc/${P}/zdoom.txt.* for more info"
}
