# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils games

MY_PN="AssaultCube"
DESCRIPTION="Fast and fun first-person-shooter based on the Cube fps"
HOMEPAGE="http://assault.cubers.net"
SRC_URI="mirror://sourceforge/actiongame/AssaultCube%20Version%20${PV}/${MY_PN}_v${PV}.tar.bz2
	mirror://sourceforge/actiongame/AssaultCube%20Version%20${PV}/${MY_PN}_v${PV}_source.tar.bz2
	http://dev.gentoo.org/~hasufell/distfiles/${PN}.png"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated doc server"

RDEPEND="
	>=net-libs/enet-1.3.0:1.3
	sys-libs/zlib
	!dedicated? (
		media-libs/libsdl[X,opengl,video]
		media-libs/libogg
		media-libs/libvorbis
		media-libs/openal
		media-libs/sdl-image[jpeg,png]
		virtual/opengl
		x11-libs/libX11
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1.0.4-QA.patch

	# remove unsued stuff
	rm -r bin_unix/* || die
	find packages -name readme.txt -delete || die

	# respect FHS and fix binary name
	sed -i \
		-e "/^CUBE_DIR=/d ; 2iCUBE_DIR=$(games_get_libdir)/${PN}" \
		-e "s:bin_unix/\${SYSTEM_NAME}\${MACHINE_NAME}:ac_:" \
		-e "s:cd \${CUBE_DIR}:cd ${GAMES_DATADIR}/${PN}:" \
		${PN}.sh server.sh || die

	# remove bundled enet
	rm -r source/enet || die
}

src_compile() {
	BUNDLED_ENET=NO \
		emake -C source/src \
		$(usex dedicated "" "client") \
		$(usex dedicated "server" "$(usex server "server" "")")
}

src_install() {
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r config packages

	exeinto "$(games_get_libdir)/${PN}"
	if ! use dedicated ; then
		doexe source/src/ac_client
		newgamesbin ${PN}.sh ${PN}
		make_desktop_entry ${PN} ${MY_PN} ${PN}
	fi

	if use dedicated || use server ; then
		doexe source/src/ac_server
		newgamesbin server.sh ${PN}-server
		make_desktop_entry ${PN}-server "${MY_PN} Server" ${PN}
	fi

	doicon -s 48 "${DISTDIR}"/${PN}.png

	if use doc ; then
		rm -r docs/autogen || die
		dohtml -r docs/*
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
