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
IUSE="server"
RESTRICT="strip"

DEPEND="x86? (
		media-libs/libpng
		media-libs/libsdl[opengl]
		media-libs/sdl-mixer
		media-libs/sdl-image[png]
	)
	amd64? (
		app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-sdl
	)"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}
DIR="${GAMES_DATADIR}"/${PN}

QA_PRESTRIPPED="${DIR:1}/bfclient
		${DIR:1}/bfserver"

src_install() {
	use amd64 && multilib_toolchain_setup x86

	exeinto "${DIR}"
	doexe bin/bfclient || die "doexe failed"

	insinto "${DIR}"
	doins -r data || die "doins failed"

	games_make_wrapper bloodfrontier-client ./bfclient "${DIR}" "${DIR}"

	if use server ; then
		doexe bin/bfserver || die "doexe failed"
		games_make_wrapper bloodfrontier-server ./bfserver "${DIR}" "${DIR}"
	fi

	dodoc readme.txt || die "dodoc failed"

	doicon "${FILESDIR}"/"${PN}".png || die "doicon failed"
	make_desktop_entry bloodfrontier-client "Blood Frontier" ${PN}

	prepgamesdirs
}
