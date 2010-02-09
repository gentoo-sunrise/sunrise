# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils subversion

DESCRIPTION="the fast media tag lib"
HOMEPAGE="http://mtag.berlios.de/"
SRC_URI=""
ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/mtag/trunk/mtag"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="media-libs/taglib
	>=dev-db/sqlite-3.3.12"
DEPEND="doc? ( app-doc/doxygen )
	${RDEPEND}"

CMAKE_IN_SOURCE_BUILD=1

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		doxygen "${S}" || die "compile failed!"
	fi
}

src_install() {
	dobin mtag || die "dobin failed"
	dodoc README ChangeLog AUTHORS || die "dodoc failed"
	if use doc; then
		dohtml -r html/* || die "dohtml failed"
	fi
}
