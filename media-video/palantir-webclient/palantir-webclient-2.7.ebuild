# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp java-utils-2

MY_PN=${PN/-webclient/}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Transmit live video, audio and data over a TCP/IP network, as well as to control remote devices."
HOMEPAGE="http://www.fastpath.it/products/palantir/index.php"
SRC_URI="http://www.fastpath.it/products/${MY_PN}/pub/${MY_P}.tgz"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${MY_P}/clients/java

src_compile() {
	ejavac *.java || die "ejavac failed!"
	jar cfm pclient.jar MANIFEST.MF *.class || die "jar failed!"
}

src_install() {
	webapp_src_preinst
	cp *.jar *.html "${D}/${MY_HTDOCSDIR}"
	dodoc README TODO
	webapp_postinst_txt en "${FILESDIR}/postinstall-en-${PV}.txt"
	webapp_src_install
}
