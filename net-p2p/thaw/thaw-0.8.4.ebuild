# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A filesharing utility and upload/download manager for freenet"
HOMEPAGE="http://wiki.freenetproject.org/Thaw/"
SRC_URI="http://dev.gentooexperimental.org/~tommy/${P}.tar.bz2"
LICENSE="GPL-3"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/jmdns
	dev-db/hsqldb
	dev-java/bcprov"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.4
	|| ( net-p2p/freenet
	net-p2p/freenet-bin )"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.4
	dev-java/ant
	dev-java/jmdns
	dev-db/hsqldb"
S="${WORKDIR}/thaw"

src_unpack() {
	unpack ${A}
	cd "${S}"/lib
	java-pkg_jar-from jmdns
	java-pkg_jar-from hsqldb
	java-pkg_jar-from bcprov bcprov.jar BouncyCastle.jar
}

src_install() {
	insinto /opt/thaw
	doins bin/Thaw.jar
	echo "cd /opt/thaw">thaw
	echo "java -jar Thaw.jar">>thaw
	dobin thaw
	dosym /usr/share/jmdns/lib/jmdns.jar /opt/thaw/
	dosym /usr/share/hsqldb/lib/hsqldb.jar /opt/thaw
	dosym /usr/share/bcprov/lib/bcprov.jar /opt/thaw/BouncyCastle.jar
}

pkg_postinst() {
	chmod  o+w /opt/thaw
}

pkg_postrm() {
	elog "If you dont want to use thaw any more"
	elog "and dont want to keep your identities/other stuff"
	elog "remember to do 'rm -rf /opt/thaw' do remove everything"
}
