# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

MY_PN="Rainlendar-Lite"
MY_P=${MY_PN}-${PV}
DESCRIPTION="Feature rich calendar application that is easy to
use and doesn't take much space on your desktop."
HOMEPAGE="http://www.rainlendar.net"
SRC_URI="http://www.rainlendar.net/download/${MY_P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
REPEND="amd64? ( app-emulation/emul-linux-x86-gtklibs
                 app-emulation/emul-linux-x86-xlibs
                 app-emulation/emul-linux-x86-baselibs )
        x86? ( >=x11-libs/gtk+-2
               dev-libs/atk
               x11-libs/libXext
               x11-libs/libXi
               x11-libs/libXinerama
               x11-libs/libXrandr
               x11-libs/libXcursor
               x11-libs/libXcomposite
               x11-libs/libXdamage
               x11-libs/pango )"

S=${WORKDIR}/rainlendar2

RESTRICT="mirror strip"

QA_TEXTRELS="opt/rainlendar2/plugins/iCalendarPlugin.so"

pkg_setup() {
	if use x86 -a ! built_with_use '=x11-libs/gtk+-2*' xinerama ; then
		einfo "Please re-emerge x11-libs/gtk+ with the xinerama USE flag set"
		die "rainlendar needs the xinerama USE flag set"
	fi
}

src_install() {
	insinto /opt/rainlendar2
	doins -r locale plugins resources scripts skins rainlendar2.htb
	# the executable searches in . for the dirs above
	exeinto /opt/rainlendar2
	doexe rainlendar2
	dosym /opt/rainlendar2/rainlendar2 /usr/bin/rainlendar2
	dodoc Changes.txt
}
