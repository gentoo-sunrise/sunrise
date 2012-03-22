# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games git-2 multilib scons-utils

DESCRIPTION="A single-player fantasy game"
HOMEPAGE="http://www.bay12games.com/dwarves"
EGIT_REPO_URI="git://github.com/Baughn/Dwarf-Fortress--libgraphics-.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
		media-libs/fmod:1
		media-libs/freetype
		media-libs/libsdl[opengl,video,X]
		media-libs/libsndfile[alsa]
		media-libs/openal
		media-libs/sdl-image[png,tiff,jpeg]
		media-libs/sdl-ttf
		sys-libs/zlib
		x11-libs/cairo[xcb,X]
		x11-libs/gtk+:2[xinerama]
		x11-libs/libXcomposite
		x11-libs/libXcursor
		x11-libs/pango[X]"
RDEPEND="
	virtual/glu
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-gtklibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-xlibs
	)
	x86? (
		${COMMON_DEPEND}
	)"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
	amd64? (
		${COMMON_DEPEND}
	)"

QA_PREBUILT="opt/${PN}/libs/Dwarf_Fortress"

pkg_setup() {
	games_pkg_setup

	if use amd64; then
		if ! has_multilib_profile; then
			ewarn "You must be on a multilib profile to use dwarf fortress!"
			die "No multilib profile"
		fi
		multilib_toolchain_setup x86
	fi
}

src_prepare() {
	# fix broken build system...
	cp -f "${FILESDIR}"/SConscript-gentoo g_src/SConscript || die
}

src_compile() {
	# compile libgraphics.so
	escons || die
}

src_install() {
	# install config stuff
	insinto "${GAMES_SYSCONFDIR}"/${PN}
	doins -r data/init/* || die

	# keep saves, movies and objects directories
	keepdir "${GAMES_STATEDIR}"/${PN}/save \
		"${GAMES_STATEDIR}"/${PN}/movies \
		"${GAMES_STATEDIR}"/${PN}/objects || die

	# install data-files and libs
	local gamesdir="${GAMES_PREFIX_OPT}/${PN}"
	insinto "${gamesdir}"
	rm -r data/init || die
	doins -r raw data || die
	insinto "${gamesdir}"/libs
	doins libs/Dwarf_Fortress || die

	# install compiled lib and wrapper
	dogameslib libs/libgraphics.so || die
	newgamesbin "${FILESDIR}"/${PN}-wrapper ${PN} || die

	dodoc README.linux *.txt || die

	# create symlinks for several directories we want to have 
	# in a different place
	dosym "${GAMES_SYSCONFDIR}"/${PN} "${gamesdir}"/data/init || die
	dosym "${GAMES_STATEDIR}"/${PN}/save "${gamesdir}"/data/save || die
	dosym "${GAMES_STATEDIR}"/${PN}/movies "${gamesdir}"/data/movies || die
	dosym "${GAMES_STATEDIR}"/${PN}/objects "${gamesdir}"/data/objects || die

	prepgamesdirs

	# fix a few permissions
	fperms 0755 "${gamesdir}"/libs/Dwarf_Fortress || die
	fperms -R g+w "${GAMES_STATEDIR}"/${PN} || die
	fperms g+w "${gamesdir}"/data/index || die
	fperms -R g+w "${gamesdir}"/data/{announcement,dipscript,help} || die
}

pkg_postinst() {
	games_pkg_postinst

	einfo ""
	einfo "If you use a different OpenGL implementation than xorg-x11"
	einfo "libgraphics.so library will be linked against it."
	einfo "That dependency is _not_ covered by this ebuild."
	einfo ""
}
