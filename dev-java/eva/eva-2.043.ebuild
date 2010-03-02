# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P=EvA2

DESCRIPTION="An Evolutionary Algorithms Framework"
HOMEPAGE="http://www.ra.cs.uni-tuebingen.de/software/EvA2"
SRC_URI="http://www.ra.cs.uni-tuebingen.de/software/${MY_P}/downloads/${MY_P}BaseSrc.tar.gz -> ${MY_P}BaseSrc-${PV}.tar.gz
	doc? ( http://www.ra.cs.uni-tuebingen.de/software/${MY_P}/${MY_P}Doc/${MY_P}Doc.pdf
	http://tobias-lib.uni-tuebingen.de/volltexte/2005/1702/pdf/JOptDocumentation.pdf )"

LICENSE="GPL-3 LGPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S=${WORKDIR}

src_prepare() {
	cp "${FILESDIR}"/build-${PV}.xml build.xml || die "copying build.xml failed"
	mv resources lib/ || die "failed to move resources"
}

src_install() {
	java-pkg_dojar ${MY_P}Base.jar

	if use doc; then
		java-pkg_dojavadoc docs
		dodoc "${DISTDIR}"/{${MY_P}Doc,JOptDocumentation}.pdf || die "dodoc failed"
	fi

	use source && java-pkg_dosrc src

	java-pkg_dolauncher ${MY_P} --main eva2.client.EvAClient
}
