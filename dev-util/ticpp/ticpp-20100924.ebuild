# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A completely new interface to TinyXML that uses MANY of the C++ strengths"
HOMEPAGE="http://code.google.com/p/ticpp/"
SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64"
SLOT="0"
IUSE="debug doc"

DEPEND="dev-util/premake
	doc? ( app-doc/doxygen sys-apps/sed )"
RDEPEND=""

src_compile() {
	local myconf

	premake --target gnu || die "creating Makefile failed"

	if use !debug ; then
		myconf="CONFIG=Release"
	fi

	emake ${myconf} || die "emake failed"

	if use doc ; then
		sed -i -e '/GENERATE_HTMLHELP/s:YES:NO:' dox || die "sed failed"
		doxygen dox || die "doxygen failed"
	fi
}

src_install () {
	insinto /usr/include/ticpp
	doins *.h || die "installing headers failed"

	if use debug ; then
		dolib ../lib/libticppd.a || die "installing library failed"
	else
		dolib ../lib/libticpp.a || die "installing library failed"
	fi

	dodoc {changes,readme,tutorial_gettingStarted,tutorial_ticpp}.txt || \
		die "dodoc failed"

	if use doc ; then
		dohtml -r docs/* || die "installing docs failed"
	fi
}
