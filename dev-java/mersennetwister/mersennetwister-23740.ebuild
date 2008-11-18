# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Modified MersenneTwister java port for Freenet"
HOMEPAGE="http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html"
SRC_URI="http://dev.gentooexperimental.org/~tommy/distfiles/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/bzip2"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}"/build.xml .
}

src_install() {
	java-pkg_dojar "${PN}.jar"
}

