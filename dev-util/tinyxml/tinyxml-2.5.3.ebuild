# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="A simple C++ XML parser that can be easily integrating into other programs"
HOMEPAGE="http://www.grinninglizard.com/tinyxml/index.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV//./_}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc examples"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

S="${WORKDIR}/${PN}"

src_compile() {
$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} -fPIC -c -o tinystr.os -DTIXML_USE_STL tinystr.cpp || die
$(tc-getCXX) ${CFLAGS} ${LDFLAGS} -fPIC -c -o tinyxml.os -DTIXML_USE_STL tinyxml.cpp || die
$(tc-getCXX) ${CFLAGS} ${LDFLAGS} -fPIC -c -o tinyxmlerror.os tinyxmlerror.cpp || die
$(tc-getCXX) ${CFLAGS} ${LDFLAGS} -fPIC -c -o tinyxmlparser.os -DTIXML_USE_STL tinyxmlparser.cpp || die
$(tc-getCXX) ${CFLAGS} ${LDFLAGS} -fPIC -Wl,-soname -Wl,tinyxml.so -o libtinyxml.so -shared tinystr.os tinyxml.os tinyxmlerror.os tinyxmlparser.os || die
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
