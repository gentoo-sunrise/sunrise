# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils games multilib toolchain-funcs

DESCRIPTION="Fast and fun first-person-shooter based on the Cube fps"
HOMEPAGE="http://assault.cubers.net"
MY_PN="AssaultCube"
MY_PV_BASE=1.0.2
SRC_URI="mirror://sourceforge/actiongame/${MY_PN}_v${MY_PV_BASE}.tar.bz2
	mirror://sourceforge/actiongame/${MY_PN}_v${PV}-Update.tar.bz2
	https://sourceforge.net/tracker/download.php?group_id=123597&atid=697091&file_id=372520&aid=2995297 -> ${P}-Makefile.patch
	https://sourceforge.net/tracker/download.php?group_id=123597&atid=697091&file_id=372519&aid=2995297 -> ${P}-enet.patch"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated doc opengl"

RDEPEND="opengl? (
		media-libs/libsdl
		media-libs/libogg
		media-libs/libvorbis
		media-libs/openal
		media-libs/sdl-image
		virtual/opengl
		x11-libs/libX11
	)"
DEPEND="${RDEPEND}
	media-libs/netpbm
	net-libs/enet"

S=${WORKDIR}/${MY_PN}_v${MY_PV_BASE}

pkg_setup() {
	if ! use dedicated && ! use opengl ; then
		eerror "You need to set USE=dedicated for game server or USE=opengl for game client."
		die
	fi
}

src_unpack() {
	unpack ${MY_PN}_v${MY_PV_BASE}.tar.bz2
	cd "${S}" || die
	unpack ${MY_PN}_v${PV}-Update.tar.bz2
}

src_prepare() {
	rm -r bin_unix/* source/include source/enet || die
	find packages -name readme.txt -delete || die
	winicontoppm icon.ico | ppmtoxpm > ${PN}.xpm || die

	epatch "${DISTDIR}"/${P}-Makefile.patch
	epatch "${DISTDIR}"/${P}-enet.patch

	sed -i -e "/^CUBE_DIR=/d ; 2iCUBE_DIR=${GAMES_DATADIR}/${PN}" ${PN}.sh server.sh || die
	sed -i -e "s:\${CUBE_DIR}/bin_unix/\${SYSTEM_NAME}\${MACHINE_NAME}:$(games_get_libdir)/${PN}/ac_:" ${PN}.sh server.sh || die
}

src_compile() {
	emake -C source/src \
		CC="$(tc-getCXX)" \
		CXXOPTFLAGS="${CXXFLAGS}" \
		$(use opengl && echo client) \
		$(use dedicated && echo server) || die
}

src_install() {
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r bot config packages || die

	exeinto "$(games_get_libdir)/${PN}"
	if use opengl ; then
		doexe source/src/ac_client || die
		newgamesbin ${PN}.sh ${PN} || die
		make_desktop_entry ${PN} ${MY_PN} ${PN}
	fi
	if use dedicated ; then
		doexe source/src/ac_server || die
		newgamesbin server.sh ${PN}-server || die
		make_desktop_entry ${PN}-server "${MY_PN} Server" ${PN}
	fi
	insinto /usr/share/pixmaps
	doins ${PN}.xpm || die

	if use doc ; then
		dohtml -r docs/* || die
	fi

	prepgamesdirs
}
