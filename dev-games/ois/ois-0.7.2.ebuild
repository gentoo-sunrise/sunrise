# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Object-oriented Input System - A cross-platform C++ input handling library"
HOMEPAGE="http://www.wreckedgames.com/wiki/index.php/WreckedLibs:OIS"
SRC_URI="mirror://sourceforge/wgois/${PN}-${PV//./-}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~x86"
IUSE="nojoyevents"
S=${WORKDIR}/ois

RDEPEND="x11-libs/libXaw
	x11-libs/libX11"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf
	sed -i -e 's:/usr/local:/usr:' demos/ogre/common/plugins.cfg
}

src_compile() {
	if use nojoyevents ; then
		myconf= --disable-joyevents
	fi

	if !( has_version '>=dev-games/cegui-0.4.0' && ! built_with_use dev-games/ogre sdl ) ; then
		myconf= ${myconf} --disable-ogre
	fi

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	rm demos/Make*
	rm demos/ogre/Make*
	insinto /usr/share/doc/${PF}
	doins -r demos
	exeinto /usr/share/doc/${PF}/demos
	doexe demos/.libs/{FFConsoleTest,ConsoleApp}
	if has_version '>=dev-games/cegui-0.4.0' && ! built_with_use dev-games/ogre sdl ; then
		exeinto /usr/share/doc/${PF}/demos/ogre/common/
		doexe demos/ogre/.libs/{ForceFeedback,ActionMap}
	fi
}

pkg_postinst() {
	if has_version '>=dev-games/cegui-0.4.0' && ! built_with_use dev-games/ogre sdl ; then
		elog "If you want the Ogre demos, you have to install Ogre without SDL and CEGui."
		elog "USE=-sdl && emerge ogre cegui"
		elog "Then just remerge this package."
	fi
}
