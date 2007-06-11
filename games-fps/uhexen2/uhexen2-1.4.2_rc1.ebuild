# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs versionator games

DATA_PV="1.19-rc1"
HW_PV="0.15"
MY_PN="hexen2"
MY_PV=$(replace_version_separator 3 '-')
DEMO_PV="1.4.1"

DESCRIPTION="Hexen 2 port - Hammer of Thyrion"
HOMEPAGE="http://uhexen2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}source-${MY_PV}.tgz
	mirror://sourceforge/${PN}/gamedata-all-${DATA_PV}.tgz
	hexenworld? ( mirror://sourceforge/${PN}/hexenworld-pakfiles-${HW_PV}.tgz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa cdaudio debug dedicated demo dynamic hexenworld gtk lights opengl
optimize-cflags oss sdlaudio sdlcd timidity tools"

QA_EXECSTACK="${GAMES_BINDIR:1}/hexen2
	${GAMES_BINDIR:1}/glhexen2
	${GAMES_BINDIR:1}/hexen2-demo
	${GAMES_BINDIR:1}/glhexen2-demo
	${GAMES_BINDIR:1}/hwcl
	${GAMES_BINDIR:1}/glhwcl
	${GAMES_BINDIR:1}/hwcl-demo
	${GAMES_BINDIR:1}/glhwcl-demo"

UIDEPEND=">=media-libs/libsdl-1.2.7
	>=media-libs/sdl-mixer-1.2.5
	alsa? ( >=media-libs/alsa-lib-1.0.7 )
	opengl? ( virtual/opengl )
	timidity? ( media-sound/timidity++ )
	amd64? ( virtual/opengl )"

# Launcher depends from GTK+ libs
LNCHDEPEND="gtk? ( =x11-libs/gtk+-2* )"

# xdelta is needed to manually run the patch script
RDEPEND="!games-fps/uhexen2-cvs
	${UIDEPEND}
	${LNCHDEPEND}
	demo? ( >=games-fps/hexen2-demodata-${DEMO_PV} )
	lights? ( games-fps/hexen2-lights )
	>=dev-util/xdelta-1.1.3-r1"
DEPEND="${UIDEPEND}
	${LNCHDEPEND}
	x86? ( >=dev-lang/nasm-0.98.38 )"

S=${WORKDIR}/hexen2source-${MY_PV}
dir=${GAMES_DATADIR}/${MY_PN}

pkg_setup() {
	games_pkg_setup

	if use timidity ; then
		if ! built_with_use "media-libs/sdl-mixer" timidity ; then
			eerror "Recompile media-libs/sdl-mixer with 'timidity' USE flag."
			die "sdl-mixer without timidity support detected"
		fi
		if use sdlaudio ; then
			ewarn "timidity (midi music) does not work with sdlaudio."
		fi
	else
		ewarn "timidity is needed if midi music is desired."
	fi

	! use alsa && ewarn "alsa is the recommended sound driver."
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-h2launcher_improvements.diff"
	cd hexen2
	epatch "${S}/00_Patches/external-music-file-support.diff"
	cd ..

	# Fix a little bug in cd_null.c
	sed -i \
		-e "/\#endif/d" \
		{hexen2,hexenworld/Client}/cd_null.c \
		|| die "sed cd_null.c failed"

	# Whether to use the demo directory
	local demo
	use demo && demo="/demo"

	# Use default basedir - has 2 variations
	sed -i \
		-e "s:parms.basedir = cwd;:parms.basedir = \"${dir}${demo}\";:" \
		-e "s:parms.basedir = \".\";:parms.basedir = \"${dir}${demo}\";:" \
		{hexen2,hexen2/server,hexenworld/{Client,Server}}/sys_unix.c \
		|| die "sed sys_unix.c failed"

	# Change default sndspeed from 11025 to 44100,
	# to improve the quality/reliability.
	sed -i \
		-e "s:desired_speed = 11025:desired_speed = 44100:" \
		{hexen2,hexenworld/Client}/snd_dma.c || die "sed snd_dma.c failed"

	# Change patch script to be suitable
	sed -i \
		-e "s:chmod :#chmod :" \
		-e 's:"xdelta113":"/usr/bin/xdelta":' \
		-e "s:./xdelta113:xdelta": \
		"${WORKDIR}"/update_xdelta.sh || die "sed update_xdelta.sh failed"

	if use demo ; then
		# Allow lightmaps in demo
		sed -i \
			-e "s:!override_pack:0:" \
			hexen2/common.c || die "sed common.c demo failed"
	fi

	if use gtk ; then
		# Tweak the default games data dir for graphical launcher
		sed -i \
			-e "/char game_basedir/s:;: = \"${dir}${demo}\";:" \
			-e "/int basedir_nonstd/s:= 0:= 1:" \
			-e "/game_basedir\[0\]/d" \
			launcher/config_file.c || die "sed config_file.c failed"
		# Tweak the default name for binary executables,if DEMO version is enabled
		if use demo ; then
			sed -i \
				-e "/BINARY_NAME/s:\"$:-demo\":" \
				launcher/games.h || die "sed games.g failed"
		fi
	fi

	rm -rf docs/{activision,COMPILE,COPYING,LICENSE,README.win32}
}

src_compile() {
	yesno() { useq $1 && echo yes || echo no ; }

	local h2bin="h2" hwbin="hw" link_gl_libs="no" opts

	if use opengl ; then
		if use amd64 ; then
			# On AMD64 can be built only OpenGL binaries
			h2bin="gl${h2bin}"
			hwbin="gl${hwbin}"
		else
			h2bin="${h2bin} gl${h2bin}"
			hwbin="${hwbin} gl${hwbin}"
		fi
		link_gl_libs=$(yesno dynamic)
	fi

	use debug && opts="${opts} DEBUG=1"
	use demo && opts="${opts} DEMO=1"

	if use gtk ; then
	# Build launcher
		cd "${S}/launcher"
		einfo "Compiling graphical launcher"
		emake \
			AUTOTOOLS=1 \
			${opts} \
			CPUFLAGS="${CFLAGS}" \
			CC="$(tc-getCC)" \
			|| die "emake launcher failed"
	fi

	if use tools ; then
		# Build Hexen2 utils
		cd "${S}/utils"
		einfo "Compiling utils"
		local utils_list="hcc maputils genmodel qfiles dcc jsh2color hcc_old"
		for x in ${utils_list}
		do
			emake -C ${x} \
				${opts} \
				CPUFLAGS="${CFLAGS}" \
				CC="$(tc-getCC)" \
				|| die "emake ${x} failed"
		done
	fi

	if use dedicated ; then
		# Dedicated Server
		cd "${S}/${MY_PN}"
		einfo "Compiling Dedicated Server"
		emake \
			${opts} \
			OPT_EXTRA=$(yesno optimize-cflags) \
			CPUFLAGS="${CFLAGS}" \
			CC="$(tc-getCC)" \
			-f Makefile.sv \
			|| die "emake Dedicated server failed"
	fi

	if use hexenworld ; then
		if use tools; then
			# Hexenworld utils
			local hw_utils="hwmquery hwrcon"
			einfo "Compiling Hexenworld utils"
			cd "${S}/hw_utils"
			for x in ${hw_utils} ; do
				emake \
					${opts} \
					CPUFLAGS="${CFLAGS}" \
					CC="$(tc-getCC)" \
					-C ${x} \
					|| die "emake ${x} failed"
			done
		fi

		# Hexenworld
		einfo "Compiling Hexenworld servers"
		cd "${S}"/hexenworld
		# Hexenworld servers
		emake \
			${opts} \
			CPUFLAGS="${CFLAGS}" \
			CC="$(tc-getCC)" \
			-C Server \
			|| die "emake HexenWorld Server failed"
		emake \
			${opts} \
			CPUFLAGS="${CFLAGS}" \
			CC="$(tc-getCC)" \
			-C Master \
			|| die "emake HexenWorld Master failed"

		# Hexenworld client
		einfo "Compiling Hexenworld client(s)"
		use amd64 && ewarn "On AMD64 only GL Hexenworld client version is built"
		for m in ${hwbin} ; do
			emake -C Client clean
			emake \
				${opts} \
				USE_ALSA=$(yesno alsa) \
				USE_OSS=$(yesno oss) \
				USE_CDAUDIO=$(yesno cdaudio) \
				USE_MIDI=$(yesno timidity) \
				USE_SDLAUDIO=$(yesno sdlaudio) \
				USE_SDLCD=$(yesno sdlcd) \
				USE_X86_ASM=$(yesno x86) \
				OPT_EXTRA=$(yesno optimize-cflags) \
				LINK_GL_LIBS=${link_gl_libs} \
				CPUFLAGS="${CFLAGS}" \
				CC="$(tc-getCC)" \
				${m} \
				-C Client \
				|| die "emake Hexenworld Client (${m}) failed"
		done
	fi

	# Hexen 2 game executable
	cd "${S}/${MY_PN}"

	einfo "Compiling UHexen2 game executable(s)"
	use amd64 && ewarn "On AMD64 only GL game binary version is built"
	for m in ${h2bin} ; do
		emake clean
		emake \
			${opts} \
			USE_ALSA=$(yesno alsa) \
			USE_OSS=$(yesno oss) \
			USE_CDAUDIO=$(yesno cdaudio) \
			USE_MIDI=$(yesno timidity) \
			USE_SDLAUDIO=$(yesno sdlaudio) \
			USE_SDLCD=$(yesno sdlcd) \
			USE_X86_ASM=$(yesno x86) \
			OPT_EXTRA=$(yesno optimize-cflags) \
			LINK_GL_LIBS=${link_gl_libs} \
			CPUFLAGS="${CFLAGS}" \
			CC="$(tc-getCC)" \
			${m} \
			|| die "emake Hexen2 (${m}) failed"
	done

}

src_install() {
	local demo demo_title demo_suffix
	use demo && demo="-demo" && demo_title=" (Demo)" && demo_suffix="demo"

	newicon hexen2/icons/h2_32x32x4.png ${PN}.png || die
	if ! use amd64 ; then
		make_desktop_entry "${MY_PN}${demo}" "Hexen 2${demo_title}" ${PN}.png
		newgamesbin "${MY_PN}/${MY_PN}" "${MY_PN}${demo}" \
			|| die "newgamesbin ${MY_PN} failed"
	fi
	if use opengl || use amd64 ; then
		make_desktop_entry "gl${MY_PN}${demo}" "GLHexen 2${demo_title}" ${PN}.png
		newgamesbin "${MY_PN}/gl${MY_PN}" "gl${MY_PN}${demo}" \
			|| die "newgamesbin gl${MY_PN} failed"
	fi

	if use dedicated ; then
		newgamesbin "${MY_PN}"/h2ded "${MY_PN}${demo}-ded" \
			|| die "newgamesbin h2ded failed"
	fi

	if use hexenworld ; then
		if use tools; then
			# Hexenworld utils
			dobin hw_utils/hwmquery/hwmquery || die "dobin hwmquery failed"
			dobin hw_utils/hwrcon/{hwrcon,hwterm} || die "dobin hwrcon/hwterm failed"

			dodoc hw_utils/hwmquery/hwmquery.txt || die "dodoc hwmquery.txt failed"
			dodoc hw_utils/hwrcon/{hwrcon,hwterm}.txt \
			|| die "dodoc hwrcon/hwterm.txt failed"
		fi

		# Hexenworld Servers
		newgamesbin hexenworld/Server/hwsv hwsv${demo} \
			|| die "newgamesbin hwsv failed"

		newgamesbin hexenworld/Master/hwmaster hwmaster${demo} \
			|| die "newgamesbin hwmaster failed"

		# HexenWorld client(s)
		newicon hexenworld/icons/hw2_32x32x8.png hwcl.png || die
		if ! use amd64 ; then
			make_desktop_entry \
				"hwcl${demo}" "Hexen 2${demo_title} Hexenworld Client" hwcl.png
			newgamesbin "hexenworld/Client/hwcl" "hwcl${demo}" \
				|| die "newgamesbin hwcl failed"
		fi
		if use opengl || use amd64; then
			make_desktop_entry \
				"glhwcl${demo}" "GLHexen 2${demo_title} Hexenworld Client" hwcl.png
			newgamesbin "hexenworld/Client/glhwcl" "glhwcl${demo}" \
				|| die "newgamesbin glhwcl failed"
		fi

		insinto "${dir}"/${demo_suffix}
		doins -r "${WORKDIR}"/hw || die "doins hexenworld pak failed"
	fi

	if use gtk ; then
		# GTK launcher
		local lnch_name="h2launcher"
		use demo && lnch_name="h2demo"
		newgamesbin launcher/${lnch_name} h2launcher \
			|| die "newgamesbin h2launcher failed"
		make_desktop_entry \
			"h2launcher" "Hexen 2${demo_title} Launcher" ${PN}.png
	fi

	# Forge a new useful document 8)
	head -22 "00_Patches/external-music-file-support.diff" > \
	"docs/external_music.README" || die "make readme failed"

	dodoc docs/*

	if ! use demo ; then
		# Install updated game data
		insinto "${dir}"
		doins -r "${WORKDIR}"/{data1,patchdata,portals,siege} || die
		# Patching should really be done by a future "hexen2-data" ebuild.
		# But this works for now.
		doins "${WORKDIR}"/update_xdelta.sh || die
		dodoc "${WORKDIR}"/*.txt
	fi

	if use tools ; then
		dobin \
		utils/bin/{bspinfo,dhcc,genmodel,hcc,jsh2colour,light,qbsp,qfiles,vis} \
			|| die "dobin utils failed"
		newbin utils/hcc_old/hcc hcc_old || die "newbin hcc_old failed"
		docinto utils
		dodoc utils/README || die "dodoc README failed"
		dodoc utils/bin/hcc.txt || die "dodoc hcc.txt failed"
		newdoc utils/dcc/README README.dcc || die "newdoc dcc.txt failed"
		dodoc utils/dcc/dcc.txt || die "dodoc dcc.txt failed"
		newdoc utils/hcc_old/README hcc_old.txt || die "newdoc hcc_old failed"
		newdoc utils/jsh2color/README README.jsh2color \
			|| die "newdoc README.jsh2color failed"
		newdoc utils/jsh2color/ChangeLog ChangeLog.jsh2color \
			|| die "newdoc Changelog.jsh2color failed"
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if ! use timidity ; then
		elog "MIDI music requires the 'timidity' USE flag."
		echo
	fi

	if use demo ; then
		elog "uhexen2 has been compiled specifically to play the demo maps."
		elog "Example command-line:"
		elog "   hexen2-demo -width 1024 -height 768 -conwidth 640"
		echo
	else
		elog "To play the demo, emerge with the 'demo' USE flag."
		elog
		elog "For the Hexen 2 original game..."
		elog "Put the following files into ${dir}/data1 before playing:"
		elog "   pak0.pak pak1.pak"
		elog "Then to play:  hexen2"
		elog
		elog "For the 'Portal of Praevus' mission pack..."
		elog "Put the following file into ${dir}/portals before playing:"
		elog "   pak3.pak"
		elog "Then to play:  hexen2 -portals"
		elog
		elog "To ensure the data files from the CD are patched, run as root:"
		elog "   cd ${dir} && sh update_xdelta.sh"
		elog
		elog "Example command-line:"
		elog "   hexen2 -width 1024 -height 768 -conwidth 640"
		echo
	fi
	if use gtk ; then
		elog "You've also installed a nice graphical launcher. Simply run:"
		elog
		elog "   h2launcher"
		elog
		elog "to enjoy it :)"
		echo
	fi
	if use tools ; then
		if use hexenworld; then
			elog "You've also installed some Hexenworld utility:"
			elog
			elog " - hwmquery (console app to query HW master servers)"
			elog " - hwrcon (remote interface to HW rcon command)"
			elog " - hwterm (HW remote console terminal)"
			echo
		fi
		elog "You've also installed some Hexen2 utility"
		elog "(useful for mod developing)"
		elog
		elog " - dhcc (old progs.dat compiler/decompiler"
		elog " - genmodel (3-D model grabber"
		elog " - hcc (HexenC compiler)"
		elog " - hcc_old (old version of HexenC compiler)"
		elog " - jsh2color (light colouring utility)"
		elog " - maputils (Map compiling tools: bspinfo, light, qbsp, vis)"
		elog " - qfiles (build pak files and regenerate bsp models)"
		elog
		elog "See relevant documentation for further informations"
		echo
	fi
}
