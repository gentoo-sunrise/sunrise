# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="http://ticpp.googlecode.com/svn/trunk/"
inherit subversion

MY_PV=cvs
DESCRIPTION="A completely new interface to TinyXML that uses MANY of the C++ strengths"
HOMEPAGE="http://code.google.com/p/ticpp/"
SRC_URI=""

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
IUSE="debug examples"

DEPEND="dev-util/premake"
RDEPEND=""

S="${WORKDIR}/${PN}"

src_compile() {
	premake --target gnu || die "creating Makefile failed"
	if use debug ; then
		emake || die "emake failed"
	else
		emake CONFIG=Release || die "emake failed"
	fi
}

src_install () {
	insinto /usr/include/ticpp
	doins ticpp.h ticpprc.h || die "installing headers failed"

	if use debug ; then
		dolib libticppd.a || die "installing library failed"
	else
		dolib libticpp.a || die "installing library failed"
	fi

	dodoc {changes,readme,tutorial_gettingStarted,tutorial_ticpp}.txt
	dohtml docs/* || die "installing docs failed"

	if use examples ; then
		rm TiCppTut/TiCppTut{.cbp,.dsp,.dsw,_vc7.vcproj,.vcproj}
		insinto /usr/share/doc/${PF}/samples
		doins TiCppTut/* || die "installing examples"
	fi
}
