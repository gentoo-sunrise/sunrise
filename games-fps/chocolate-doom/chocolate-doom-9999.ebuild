# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 )
inherit autotools subversion python-any-r1 flag-o-matic games

DESCRIPTION="Doom port designed to act identically to the original game"
HOMEPAGE="http://www.chocolate-doom.org/"
ESVN_REPO_URI="https://chocolate-doom.svn.sourceforge.net/svnroot/${PN}/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="server"

DEPEND=">=media-libs/libsdl-1.1.3
	media-libs/sdl-mixer
	media-libs/sdl-net"
RDEPEND=${DEPEND}

pkg_setup () {
	games_pkg_setup
	python-any-r1_pkg_setup
}

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	# Change default search path for IWAD
	sed -i \
		-e "s:/usr/share/games/doom:${GAMES_DATADIR}/doom-data:" \
		src/d_iwad.c || die "sed main.c failed"

	sed -i \
		-e "s:^gamesdir =.*:gamesdir = ${GAMES_BINDIR}:" \
		setup/Makefile.am || die "sed Makefile.am failed"

	append-libs -lm
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-sdltest \
		--disable-dependency-tracking
}

src_install() {
	dogamesbin "src/${PN}"
	dogamesbin setup/chocolate-setup
	if use server ; then
		dogamesbin src/chocolate-server
	fi

	newicon data/doom.png "${PN}.png"
	make_desktop_entry "${PN}" "Chocolate Doom"
	newicon data/setup.png chocolate-setup.png
	make_desktop_entry chocolate-setup "Chocolate Doom Setup" chocolate-setup.png

	nonfatal doman man/*.{5,6}
	nonfatal dodoc AUTHORS BUGS CMDLINE ChangeLog NEWS README TODO

	keepdir "${GAMES_DATADIR}/doom-data"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	einfo
	einfo "To play the original Doom levels, place doom.wad and/or doom2.wad"
	einfo "into "${GAMES_DATADIR}"/doom-data, then run: ${PN}"
	einfo
	einfo "To configure game options run:  chocolate-setup"
	einfo
}
