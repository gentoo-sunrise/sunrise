# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ECVS_SERVER="tinyxml.cvs.sourceforge.net:/cvsroot/tinyxml"
ECVS_MODULE="tinyxml"
inherit eutils cvs

DESCRIPTION="A simple C++ XML parser that can be easily integrating into other programs"
HOMEPAGE="http://www.grinninglizard.com/tinyxml/index.html"
SRC_URI=""

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug doc examples"

DEPEND="dev-util/scons
	doc? ( app-doc/doxygen )"
RDEPEND=""

S="${WORKDIR}/${PN}"

src_compile() {
	local myconf

	use debug && myconf="debug=0"
	scons ${MAKEOPTS} ${myconf} sharedlibrary=1 program=0 || die "scons failed"
	if use doc ; then
		doxygen dox || die "doxygen failed"
	fi
}

src_install () {
	insinto /usr/include
	doins *.h || die "installing headers failed"
	dolib libtinyxml.so || die "installing library failed"
	dodoc {changes,readme}.txt
	if use doc ; then
		dohtml docs/* || die "installing docs"
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/samples
		doins *.xml xmltest.cpp || die "installing examples"
	fi
}
