# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A filesharing utility and upload/download manager for freenet"
HOMEPAGE="http://wiki.freenetproject.org/Thaw/"
SRC_URI="http://dev.gentooexperimental.org/~tommy/${P}.tar.bz2
	http://www.bouncycastle.org/download/bcprov-jdk14-138.jar"
LICENSE="GPL-3"
IUSE=""
SLOT="0"
KEYWORDS="~x86"
RDEPEND=">=virtual/jre-1.4
	|| ( net-p2p/freenet
	net-p2p/freenet-bin )"
DEPEND=">=virtual/jdk-1.4
	dev-java/ant
	dev-java/jmdns
	dev-db/hsqldb"
S="${WORKDIR}/thaw"

pkg_setup() {
	enewgroup thaw
}

src_unpack() {
	unpack ${P}.tar.bz2
	cd "${S}"
	cp -R /usr/share/jmdns/lib .
	cp /usr/share/hsqldb/lib/hsqldb.jar lib/
	cp "${DISTDIR}"/bcprov-jdk14-138.jar lib/BouncyCastle.jar
}

src_compile() {
	ant
}

src_install() {
	insinto /opt/thaw
	doins bin/Thaw.jar
	echo "cd /opt/thaw">thaw
	echo "java -jar Thaw.jar">>thaw
	dobin thaw
	fowners :thaw /usr/bin/thaw
	fperms o-rx /usr/bin/thaw
	fowners -R :thaw /opt/thaw
}

pkg_postinst() {
	chmod  g+rw /opt/thaw
	elog "You have to be in the thaw-group to start thaw."
	elog "use 'gpasswd -a user thaw' to add user to the thaw-group."
}

pkg_postrm() {
	elog "If you dont want to use thaw any more"
	elog "and dont want to keep your identities/other stuff"
	elog "remember to do 'rm -rf /opt/thaw' do remove everything"
}
