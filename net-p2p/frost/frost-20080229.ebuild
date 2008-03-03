# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2 eutils

DESCRIPTION="Message board and file sharing client for freenet network"
HOMEPAGE="http://jtcfrost.sourceforge.net/"
SRC_URI="http://dev.gentooexperimental.org/~tommy/${P}.tar.bz2"
LICENSE="GPL-2"
IUSE=""
SLOT="0"
KEYWORDS="~x86"
RDEPEND=">=virtual/jre-1.5
	|| ( net-p2p/freenet
	net-p2p/freenet-bin )"
DEPEND=">=virtual/jdk-1.5
	dev-java/ant"
S="${WORKDIR}/frost-wot"

pkg_setup() {
	enewgroup frost
}

src_compile() {
	eant distro
}

src_install() {
	echo "sh /opt/frost/frost.sh" >frost
	dobin frost
	cd build/dist
	insinto /opt/frost
	dodoc *txt doc/authors.txt
	doins frost.sh frost.jar
	doins -r config downloads exec lib
	dodir -p /opt/frost/store
	fowners :frost /usr/bin/frost
	fperms o-rx /usr/bin/frost
	fowners -R :frost /opt/frost
}

pkg_postinst() {
	chmod  g+rw /opt/frost
	chmod  -R g+rw /opt/frost/config /opt/frost/downloads /opt/frost/store /opt/frost/exec
	elog "You have to be in the frost-group to start frost."
	elog "use 'gpasswd -a user frost' to add user to the frost-group."
}

pkg_postrm() {
	elog "If you dont want to use frost any more"
	elog "and dont want to keep your identities/other stuff"
	elog "remember to do 'rm -rf /opt/frost' do remove everything"
}
