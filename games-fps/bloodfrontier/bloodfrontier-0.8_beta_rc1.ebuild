# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib games

DESCRIPTION="free single/multi-player shooter game, built as a total conversion of Cube Engine 2"
HOMEPAGE="http://www.bloodfrontier.com"
SRC_URI="mirror://sourceforge/${PN}/${PN}-B1-RC1-linux.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

DEPEND="virtual/opengl
	media-libs/libpng
	x86? (
		media-libs/libsdl[opengl]
		media-libs/sdl-mixer
		media-libs/sdl-image[png]
	)
	amd64? (
		app-emulation/emul-linux-x86-sdl
	)"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}
dir="$(games_get_libdir)"/${PN}

QA_PRESTRIPPED="${dir:1}/bfclient
		${dir:1}/bfserver"

src_install() {
	use amd64 && multilib_toolchain_setup x86

	exeinto "$(games_get_libdir)"/${PN}
	doexe bin/bf{client,server} || die "doexe failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data || die "doins failed"

	local x
	for x in client server ; do
		newgamesbin "${FILESDIR}"/wrapper ${PN}_${x}-bin || die
		sed -i \
			-e "s:@GENTOO_GAMESDIR@:${GAMES_DATADIR}/${PN}:g" \
			-e "s:@GENTOO_EXEC@:$(games_get_libdir)/${PN}/bf${x}:g" \
			"${D}/${GAMES_BINDIR}"/${PN}_${x}-bin \
			|| die "sed failed"
	done

	dodoc readme.txt || die "dodoc failed"

	doicon "${FILESDIR}"/"${PN}".png || die "doicon failed"
	make_desktop_entry ${PN}_client-bin "Blood Frontier" ${PN}

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	echo
	elog "To play the game, run:"
	elog " bloodfrontier_client-bin"
	echo
}
