# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

MY_PN="Rainlendar-Lite"
MY_P=${MY_PN}-${PV}
DESCRIPTION="Feature rich calendar application that is easy to use and doesn't take much space on your desktop."
HOMEPAGE="http://www.rainlendar.net"
SRC_URI="http://www.rainlendar.net/download/${MY_P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="amd64? ( app-emulation/emul-linux-x86-gtklibs
		    app-emulation/emul-linux-x86-xlibs )
	x86? ( x11-libs/gtk+:2[xinerama] )"

S=${WORKDIR}/rainlendar2

RESTRICT="mirror strip"

QA_TEXTRELS="opt/rainlendar2/plugins/iCalendarPlugin.so"

src_install() {
	insinto /opt/rainlendar2
	doins -r locale plugins resources scripts skins rainlendar2.htb
	# the executable searches in . for the dirs above
	exeinto /opt/rainlendar2
	doexe rainlendar2
	dosym /opt/rainlendar2/rainlendar2 /usr/bin/rainlendar2
	dodoc Changes.txt
}
