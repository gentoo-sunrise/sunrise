# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

MY_P=${PN}-${PV/_rc/RC}
DESCRIPTION="Object-oriented Input System - A cross-platform C++ input handling library"
HOMEPAGE="http://www.wreckedgames.com/wiki/index.php/WreckedLibs:OIS"
SRC_URI="mirror://sourceforge/wgois/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~x86"
IUSE="nojoyevents"

DEPEND="x11-libs/libXaw
	x11-libs/libX11"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf $(use_enable !nojoyevents joyevents) --disable-ogre || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	rm demos/Make*
	insinto /usr/share/doc/${PF}
	doins -r demos
	exeinto /usr/share/doc/${PF}/demos
	doexe demos/.libs/{FFConsoleTest,ConsoleApp}
}
