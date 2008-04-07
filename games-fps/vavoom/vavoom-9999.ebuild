# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

WX_GTK_VER="2.8"

inherit cmake-utils eutils subversion wxwidgets games

DESCRIPTION="Advanced source port for Doom/Heretic/Hexen/Strife"
HOMEPAGE="http://www.vavoom-engine.com/"
ESVN_REPO_URI="https://vavoom.svn.sourceforge.net/svnroot/vavoom/trunk/vavoom"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="allegro asm debug dedicated flac mad mikmod models music openal opengl
+sdl textures tools vorbis wxwindows"

QA_EXECSTACK="${GAMES_BINDIR:1}/${PN}"

# From econf:  "Vavoom requires Allegro or SDL to compile"
# SDL,like Allegro are *software* renderers in this game.
# So, if not selected through proper USEs, the default is SDL,
# without opengl (vavoom can run in software-mode only).
# To enable it, enable proper USE.
# OpenGL is the normally-desired hardware renderer, selected on command-line
# (through "-opengl" switch). This switch is also added to the desktop entry,
# if "opengl" USE flag is enabled

SDLDEPEND=">=media-libs/libsdl-1.2
	media-libs/sdl-mixer"
ALLEGDEPEND=">=media-libs/allegro-4.0"
OPENGLDEPEND="opengl? ( virtual/opengl )
	sdl? ( ${SDLDEPEND} )
	allegro? ( media-libs/allegrogl )
	!sdl? ( !allegro? ( ${SDLDEPEND} ) )"
DEPEND="media-libs/libpng
	media-libs/jpeg
	sdl? ( ${SDLDEPEND} )
	!sdl? ( allegro? ( ${ALLEGDEPEND} ) )
	!sdl? ( !allegro? ( !dedicated? ( ${OPENGLDEPEND} ) ) )
	opengl? ( ${OPENGLDEPEND} )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod )
	openal? ( media-libs/openal )
	wxwindows? ( =x11-libs/wxGTK-2.8* )"
RDEPEND="${DEPEND}
	allegro? ( media-sound/timidity++ )"
PDEPEND="models? ( >=games-fps/vavoom-models-1.4.2 )
	music? ( games-fps/vavoom-music )
	textures? ( games-fps/vavoom-textures )"

datadir=${GAMES_DATADIR}/${PN}

pkg_setup() {
	games_pkg_setup

	# Do some important check ...
	if use sdl && use allegro ; then
		echo
		ewarn "Both 'allegro' and 'sdl' USE flags enabled. Using SDL as default."
	elif ! use sdl && ! use allegro ; then
		echo
		ewarn "Both 'allegro' and 'sdl' USE flags disabled. Using SDL as default."
	fi

	# Base graphic/sound/music support is enabled?
	echo
	einfo "Doing some sanity check..."

	# Graphic/sound/opengl check
	local backend="media-libs/libsdl"

	if ! use sdl && use allegro ; then
		backend="media-libs/allegro"
	fi

	local backendflags="X alsa"

	if use opengl ; then
		[[ "${backend}" == "media-libs/libsdl" ]] && backendflags="${backendflags} opengl"
	else
		ewarn "'opengl' USE flag disabled. OpenGL is recommended, for best graphics."
	fi

	local msg="Please rebuild ${backend} with ${backendflags} USE flag enabled"
	if ! built_with_use ${backend} ${backendflags} ; then
			eerror "${msg}"
			die ${msg}
	fi

	# Music check
	if ! use allegro && ! built_with_use media-libs/sdl-mixer timidity ; then
		echo
		eerror "MIDI Music support is not configured properly!"
		eerror "Please rebuild sdl-mixer with USE 'timidity' enabled!"
		die "music support error"
	fi

	echo
	einfo "All is OK, let's build!"
}

src_unpack() {
	subversion_src_unpack
	cd "${S}"

	# Got rid of icon installation
	sed -i \
		-e "/vavoom\.png/d" \
		source/CMakeLists.txt || die "sed CMakeLists.txt failed"

	# Set shared data directory
	sed -i \
		-e "s:fl_basedir = \".\":fl_basedir = \"${datadir}\":" \
		source/files.cpp || die "sed files.cpp failed"
}

src_compile() {
	local \
		with_allegro="-DWITH_ALLEGRO=OFF" \
		with_sdl="-DWITH_SDL=OFF" \
		with_vorbis=$(cmake-utils_use_with vorbis)

	# Sdl is the default, unless sdl=off & allegro=on
	if ! use sdl && use allegro ; then
		with_allegro="-DWITH_ALLEGRO=ON"
	else
		with_sdl="-DWITH_SDL=ON"
	fi

	# Forcibly enable vorbis support if "music" USE flag is enabled
	if ! use vorbis && use music ; then
		ewarn "\"music\" USE flag requires Vorbis support enabled."
		ewarn "Forced enabling of \"vorbis\" USE flag"
		with_vorbis="-DWITH_VORBIS=ON"
	fi

	mycmakeargs="${mycmakeargs}
					-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG
					-DCMAKE_CXX_FLAGS_DEBUG=-g2
					-DDATADIR=${datadir}
					-DBINDIR="${GAMES_BINDIR}"
					-DENABLE_CLIENT=ON
					-DENABLE_WRAPPERS=OFF
					${with_allegro}
					${with_sdl}
					${with_vorbis}
					$(cmake-utils_use_with opengl OPENGL)
					$(cmake-utils_use_with openal OPENAL)
					$(cmake-utils_use_with mad LIBMAD)
					$(cmake-utils_use_with mikmod MIKMOD)
					$(cmake-utils_use_with flac FLAC)
					$(cmake-utils_use_enable debug ZONE_DEBUG)
					$(cmake-utils_use_enable dedicated SERVER)
					$(cmake-utils_use_enable asm ASM)
					$(cmake-utils_use_enable wxwindows LAUNCHER)
					-DwxWidgets_CONFIG_EXECUTABLE=${WX_CONFIG}"

	cmake-utils_src_configurein

	cmake-utils_src_make -j1
}

src_install() {
	local de_cmd="${PN}"

	cmake-utils_src_install

	# Enable OpenGL in desktop entry, if relevant USE flag is enabled
	use opengl && de_cmd="${PN} -opengl"
	doicon "source/${PN}.png" || die "doicon ${PN}.png failed"
	make_desktop_entry "${de_cmd}" "Vavoom"

	dodoc "docs/${PN}.txt" || die "dodoc vavoom.txt failed"

	if use tools ; then
		# The tools are always built
		dogamesbin utils/bin/{acc,fixmd2,vcc,vlumpy} || die "dobin utils failed"
		dodoc utils/vcc/vcc.txt || die "dodoc vcc.txt failed"
	fi

	if use wxwindows ; then
		# Install graphical launcher shortcut
		doicon utils/vlaunch/vlaunch.xpm || die "doicon vlaunch.xpm failed"
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
	elog "   vavoom -doom -opengl"
	elog
	elog "See documentation for further details."

	if use wxwindows ; then
		echo
		elog "You've also installed a nice graphical launcher. Simply run:"
		elog
		elog "   vlaunch"
		elog
		elog "to enjoy it :)"
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
