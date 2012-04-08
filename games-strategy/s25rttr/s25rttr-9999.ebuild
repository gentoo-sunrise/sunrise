# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EBZR_REPO_URI="lp:s25rttr"

inherit eutils cmake-utils bzr games

DESCRIPTION="Open Source remake of The Settlers II game"
HOMEPAGE="http://www.siedler25.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="app-arch/bzip2
	media-libs/libsamplerate
	media-libs/libsdl[X,audio,video]
	media-libs/libsndfile
	media-libs/sdl-mixer
	net-libs/miniupnpc
	virtual/opengl"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_prepare() {
	# date Sat Apr 7 2012
	epatch "${FILESDIR}"/cmake.patch
}

src_configure() {
	local mydate
	mydate=$(bzr version-info "${EBZR_STORE_DIR}/${EBZR_PROJECT}" 2> /dev/null \
		| awk '{if ($1 == "date:") {gsub("-", "",$2); print $2}}')

	local mycmakeargs=(
		-DPREFIX="${GAMES_PREFIX}"
		-DBINDIR="${GAMES_BINDIR}"
		-DDATADIR="${GAMES_DATADIR}"
		-DLIBDIR="$(games_get_libdir)/${PN}"
		-DDRIVERDIR="$(games_get_libdir)/${PN}"
		-DGAMEDIR="~/.${PN}/S2"
		-DWINDOW_VERSION="${mydate}"
		-DWINDOW_REVISION="${EBZR_REVNO}"
	)

	cmake-utils_src_configure
}

src_compile() {
	# build system uses some relative paths
	ln -s "${S}"/RTTR "${WORKDIR}"/${P}_build/RTTR || die

	cmake-utils_src_compile
}

src_install() {
	# work around dirty install-script
	cd "${WORKDIR}"/${P}_build || die
	insinto "${GAMES_DATADIR}"
	doins -r RTTR || die

	doicon "${S}"/debian/${PN}.png || die

	dogamesbin src/s25client || die
	make_desktop_entry "s25client" "Settlers RTTR" "${PN}"

	# libs
	exeinto "$(games_get_libdir)"/${PN}/video
	doexe driver/video/SDL/src/libvideoSDL.so || die
	exeinto "$(games_get_libdir)"/${PN}/audio
	doexe driver/audio/SDL/src/libaudioSDL.so || die

	dodoc RTTR/texte/{keyboardlayout.txt,readme.txt} || die
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Copy your Settlers2 cdrom content into ~/.${PN}/S2"
}
