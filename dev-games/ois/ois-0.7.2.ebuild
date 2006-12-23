# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
inherit eutils autotools

DESCRIPTION="Object-oriented Input System - A cross-platform C++ input handling library"
HOMEPAGE="http://www.wreckedgames.com/wiki/index.php/WreckedLibs:OIS"
SRC_URI="mirror://sourceforge/wgois/${PN}-${PV//./-}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples nojoyevents"
S="${WORKDIR}/${PN}"

RDEPEND="x11-libs/libXaw
	x11-libs/libX11"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf || die "eautoreconf failed"
	sed -i -e 's:/usr/local:/usr:' demos/ogre/common/plugins.cfg || die "sed failed"
}

src_compile() {
	econf $(use_enable !nojoyevents joyevents) --disable-ogre || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use examples ; then
		rm demos/Make* demos/ogre/Make*
		insinto /usr/share/doc/${PF}
		doins -r demos
		exeinto /usr/share/doc/${PF}/demos
		doexe demos/.libs/{FFConsoleTest,ConsoleApp}
	fi
}
