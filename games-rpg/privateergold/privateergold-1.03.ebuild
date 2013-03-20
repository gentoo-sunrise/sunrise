# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils unpacker games

DESCRIPTION="WC: Privateer Gemini Gold, remake of the adventure space flight simulation"
HOMEPAGE="http://privateer.sourceforge.net/"
SRC_URI="mirror://sourceforge/privateer/PrivateerGold${PV}.bz2.bin"

LICENSE="GPL-2 PGG-AL"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="amd64? ( app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-gtklibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-xlibs )
	x86? ( virtual/opengl
		x11-libs/gtk+:1
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrandr )"

S=${WORKDIR}

src_unpack() {
	unpack_makeself
}

src_install() {
	dodoc Manual.pdf || die "Installation of docs failed"
	newgamesbin "${FILESDIR}"/privscript privateergold || die "Couldn't install launcher"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r * || die "Installation of game data failed"
	make_desktop_entry ${PN} "Privateer Gemini Gold"
	prepgamesdirs
	fperms ug+x "${GAMES_DATADIR}/${PN}"/bin/{privgold,privserver,privsetup,soundserver,vsinstall.sh} || "chmod of game bins failed"
}

pkg_postinst() {
	elog "You can change game options with ${GAMES_DATADIR}/${PN}/bin/privsetup"
	elog "There is a manual and an intro under ${GAMES_DATADIR}/${PN}/"
	ewarn "Having /tmp mounted with noexec will cause the game to segfault"
	ewarn "at startup under kernel 2.6.39"
}
