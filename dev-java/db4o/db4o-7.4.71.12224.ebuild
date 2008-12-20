# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Object database for java"
HOMEPAGE="http://www.db4o.com"
SRC_URI="http://dev.gentooexperimental.org/~tommy/distfiles/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"
S=${WORKDIR}/${PN}-${PV%.*.*}

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}"/build.xml "${S}"
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	use source && java-pkg_dosrc src
}
