# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

ESVN_REPO_URI="https://svn.tigase.org/reps/tigase-utils/trunk"

inherit subversion java-pkg-2 eutils

DESCRIPTION="XMPP stanza helper utilities."
HOMEPAGE="http://www.tigase.org/en/project/utils"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-java/ant-1.7
	>=dev-java/tigase-xmltools-3.0
	>=virtual/jdk-1.6.0"

RDEPEND=">=dev-java/tigase-xmltools-3.0
	>=virtual/jre-1.6.0"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	ant clean-all

	epatch "${FILESDIR}/xmltoolsjar.patch"

	sed -i -e "s:libs=libs:xmltoolsjar=$(java-pkg_getjar tigase-xmltools tigase-xmltools.jar):" build.properties
}

src_compile() {
	ant jar || die "Compile failed"
	if use doc; then
		ant docs || die "Docs failed"
	fi
}

src_install() {
	java-pkg_dojar jars/*.jar

	use doc && java-pkg_dojavadoc docs-tigase-utils/api
	use source && java-pkg_dosrc src/main/java/
}
