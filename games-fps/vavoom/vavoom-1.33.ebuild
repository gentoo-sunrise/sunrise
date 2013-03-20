# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WX_GTK_VER="2.8"

inherit cmake-utils eutils wxwidgets games

DESCRIPTION="Advanced source port for Doom/Heretic/Hexen/Strife"
HOMEPAGE="http://www.vavoom-engine.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="allegro asm debug dedicated flac mad mikmod models music openal +sdl server textures tools vorbis wxwidgets"

# Vavoom requires either Allegro or SDL to compile.
# Set appropriate USE flags to select which library is used.

# As of 1.33, OpenGL is required and thus forced on.

SDLDEPEND="
	|| ( >=media-libs/libsdl-1.2[alsa,X,video,opengl]
		>=media-libs/libsdl-1.2[oss,X,video,opengl] )
	music? ( media-libs/sdl-mixer )
	!music? ( media-libs/sdl-mixer[timidity] )
	"
ALLEGDEPEND="
	|| ( >=media-libs/allegro-4.0[alsa,X,opengl]
		>=media-libs/allegro-4.0[oss,X,opengl] )
	"
DEPEND="media-libs/libpng:0
	virtual/jpeg
	sdl? ( ${SDLDEPEND} )
	!sdl? ( allegro? ( ${ALLEGDEPEND} ) )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod )
	openal? ( media-libs/openal )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER} )"
RDEPEND="${DEPEND}
	allegro? ( media-sound/timidity++ )"
PDEPEND="models? ( >=games-fps/vavoom-models-1.4.3 )
	music? ( games-fps/vavoom-music )
	textures? ( games-fps/vavoom-textures )"

REQUIRED_USE="^^ ( allegro sdl dedicated )
	music? ( vorbis )"

datadir=${GAMES_DATADIR}/${PN}

CMAKE_IN_SOURCE_BUILD=true

src_prepare() {
	# Got rid of icon installation
	sed -i \
		-e "/vavoom\.png/d" \
		source/CMakeLists.txt || die "sed CMakeLists.txt failed"

	# Set shared data directory
	sed -i \
		-e "s:fl_basedir = \".\":fl_basedir = \"${datadir}\":" \
		source/files.cpp || die "sed files.cpp failed"

	# Fix zlib/minizip build error
	sed -i \
		-e '1i#define OF(x) x' \
		"${S}/utils/vlumpy/ioapi.h" || die "sed iompi.h failed"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG
		-DCMAKE_CXX_FLAGS_DEBUG=
		-DDATADIR=${datadir}
		-DBINDIR="${GAMES_BINDIR}"
		-DENABLE_WRAPPERS=OFF
		$(cmake-utils_use_with allegro ALLEGRO)
		$(cmake-utils_use_with sdl SDL)
		$(cmake-utils_use_enable !dedicated CLIENT)
		$(cmake-utils_use_with !dedicated OPENGL)
		$(cmake-utils_use_with vorbis VORBIS)
		$(cmake-utils_use_with openal OPENAL)
		$(cmake-utils_use_with mad LIBMAD)
		$(cmake-utils_use_with mikmod MIKMOD)
		$(cmake-utils_use_with flac FLAC)
		$(cmake-utils_use_enable debug ZONE_DEBUG)
		$(usex dedicated "-DENABLE_SERVER=ON" "$(usex server "-DENABLE_SERVER=ON" "-DENABLE_SERVER=OFF")")
		$(cmake-utils_use_enable asm ASM)
		$(cmake-utils_use_enable wxwidgets LAUNCHER)
		-DwxWidgets_CONFIG_EXECUTABLE=${WX_CONFIG}
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile -j1
}

src_install() {
	cmake-utils_src_install

	# Create desktop entry
	make_desktop_entry "${PN}" "Vavoom"
	doicon "source/${PN}.png"

	dodoc "docs/${PN}.txt"

	if use tools ; then
		# The tools are always built
		dogamesbin utils/bin/{acc,fixmd2,vcc,vlumpy}
		dodoc utils/vcc/vcc.txt
	fi

	if use wxwidgets ; then
		# Install graphical launcher shortcut
		doicon utils/vlaunch/vlaunch.xpm
		make_desktop_entry "vlaunch" "Vavoom Launcher" "vlaunch.xpm"
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Copy or link wad files into ${datadir}"
	elog "(the files must be readable by the 'games' group)."
	elog
	elog "Example setup:"
	elog "ln -sn "${GAMES_DATADIR}"/doom-data/doom.wad "${datadir}"/"
	elog
	elog "Example command-line:"
	elog "   vavoom -doom -openal"
	elog
	elog "See documentation for further details."

	if use wxwidgets ; then
		echo
		elog "You've also installed a nice graphical launcher. Simply run:"
		elog "   vlaunch"
	fi

	if use tools; then
		echo
		elog "You have also installed some Vavoom-related utilities"
		elog "(useful for mod developing):"
		elog
		elog " - acc (ACS Script Compiler)"
		elog " - fixmd2 (MD2 models utility)"
		elog " - vcc (Vavoom C Compiler)"
		elog " - vlumpy (Vavoom Lump utility)"
		elog
		elog "See the Vavoom Wiki at http://vavoom-engine.com/wiki/ or"
		elog "Vavoom Forum at http://www.vavoom-engine.com/forums/"
		elog "for further help."
	fi
}
