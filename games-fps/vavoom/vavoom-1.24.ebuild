# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils flag-o-matic games

DESCRIPTION="Advanced source port for Doom/Heretic/Hexen/Strife"
HOMEPAGE="http://www.vavoom-engine.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="allegro asm debug dedicated external-glbsp flac mad mikmod models music
openal opengl sdl textures tools vorbis"

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
	external-glbsp? ( games-util/glbsp )"
RDEPEND="${DEPEND}
	allegro? ( media-sound/timidity++ )"
PDEPEND="models? ( >=games-fps/vavoom-models-1.4 )
	music? ( games-fps/vavoom-music )
	textures? ( games-fps/vavoom-textures )"

dir=${GAMES_DATADIR}/${PN}

pkg_setup() {
	local backend="media-libs/libsdl"

	if ! use sdl && use allegro ; then
		backend="media-libs/allegro"
	fi

	games_pkg_setup

	# Do some important check ...

	if use sdl && use allegro ; then
		echo
		ewarn "Both 'allegro' and 'sdl' USE flags enabled"
		ewarn "Set default to SDL"
	elif ! use sdl && ! use allegro ; then
		ewarn "Both 'sdl' and 'allegro' USE flags disabled"
		ewarn "Set default to SDL"
	fi

	# Base graphic/sound/music support is enabled?

	echo
	einfo "Doing some sanity check..."

	# Graphic check
	if ! built_with_use ${backend} X ; then
		echo
		eerror "Software Graphic support is not configured properly!"
		eerror "Please rebuild ${backend} with 'X' USE flag enabled"
		die "graphic support error"
	fi

	# Sound check
	if ! built_with_use ${backend} alsa ; then
		echo
		eerror "Sound support is not configured properly!"
		eerror "Please rebuild ${backend} with 'alsa' USE flag enabled"
		die "sound support error"
	fi

	# Music check
	if ! use allegro && ! built_with_use media-libs/sdl-mixer timidity ; then
		echo
		eerror "MIDI Music support is not configured properly!"
		eerror "Please rebuild sdl-mixer with USE 'timidity' enabled!"
		die "music support error"
	fi

	# OpenGL check
	if use opengl ; then
		if [ "${backend}" == "media-libs/libsdl" ] && ! built_with_use ${backend} opengl ; then
			echo
			eerror "OpenGL support is not configured properly!"
			eerror "Please rebuild ${backend} with 'opengl' USE flag enabled"
			die "opengl support error"
		fi
	else
		echo
		ewarn "'opengl' USE flag disabled. OpenGL is recommended, for best graphics."
	fi

	# Does user want external music? Vorbis support is needed
	if use music && ! use vorbis ; then
		echo
		eerror "Ogg/Vorbis support is required for external music playing"
		eerror "Please enable 'vorbis' USE flag for this package"
		die "external music support error"
	fi

	echo
	einfo "All is OK, let's build!"
}

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# Patch Makefiles to get rid of executable wrappers
	epatch ${FILESDIR}/${PN}-makefile_nowrapper.patch || die "epatch failed"

	# Set shared directory
	sed -i \
		-e "s:fl_basedir = \".\":fl_basedir = \"${dir}\":" \
		source/files.cpp || die "sed files.cpp failed"

	eautoreconf

	# Set executable filenames
	for m in $(find . -type f -name Makefile.in) ; do
		sed -i \
			-e "s:MAIN_EXE = @MAIN_EXE@:MAIN_EXE=${PN}:" \
			-e "s:SERVER_EXE = @SERVER_EXE@:SERVER_EXE=${PN}-ded:" \
			"${m}" || die "sed ${m} failed"
	done
}

src_compile() {
	local \
		allegro="--without-allegro" \
		sdl="--without-sdl"

	# Sdl is the default, unless sdl=off & allegro=on
	if ! use sdl && use allegro ; then
		allegro="--with-allegro"
	else
		sdl="--with-sdl"
	fi

	use debug && append-flags -g2

	egamesconf \
		--enable-client \
		${sdl} \
		${allegro} \
		$(use_with opengl) \
		$(use_with openal) \
		$(use_with external-glbsp) \
		$(use_with vorbis) \
		$(use_with mad libmad) \
		$(use_with mikmod) \
		$(use_with flac) \
		$(use_enable asm) \
		$(use_enable dedicated server) \
		$(use_enable debug) \
		$(use_enable debug zone-debug) \
		--with-iwaddir="${dir}" \
		--disable-dependency-tracking \
		|| die "egamesconf failed"

	# Parallel compiling seems to work (tested on 1.24)
	# I hope it would be true :P (in case i'll re-enable it later)
	emake || die "emake failed"
}

src_install() {
	local de_cmd="${PN}"

	emake DESTDIR="${D}" install || die "emake install failed"

	# Remove unneeded icon
	rm -f "${D}/${dir}/${PN}.png"

	doicon source/${PN}.png || die "doicon failed"

	# Enable OpenGL in desktop entry, if relevant USE flag is enabled
	use opengl && de_cmd="${PN} -opengl"
	make_desktop_entry "${de_cmd}" "Vavoom"

	dodoc docs/${PN}.txt || die "dodoc vavoom.txt failed"

	if use tools; then
		# The tools are always built
		dobin utils/bin/{acc,fixmd2,vcc,vlumpy} || die "dobin utils failed"
		dodoc utils/vcc/vcc.txt || die "dodoc vcc.txt failed"
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Copy or link wad files into ${dir}"
	elog "(the files must be readable by the 'games' group)."
	elog
	elog "Example setup:"
	elog "ln -sn ${GAMES_DATADIR}/doom-data/doom.wad ${dir}/"
	elog
	elog "Example command-line:"
	elog "   vavoom -doom -opengl"
	elog
	elog "See documentation for further details."

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
