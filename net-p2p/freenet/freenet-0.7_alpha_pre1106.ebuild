# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PV="${PV/0.7_alpha_pre/}"
DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="http://dev.gentooexperimental.org/~tommy/${PN}-sources-v${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-java/sun-jdk
	dev-java/ant"
RDEPEND="virtual/jre"

S="${WORKDIR}/${PN}"

QA_TEXTRELS="opt/freenet/lib/libwrapper-linux-x86-32.so"

pkg_setup() {
	enewgroup freenet
	enewuser freenet -1 -1 /opt/freenet freenet
}

src_install() {
	emake install || die "emake install failed"
	doinitd "${FILESDIR}"/freenet
	dodoc license/README license/LICENSE.Mantissa license/LICENSE.Freenet
}

pkg_postinst () {
	elog "1. Start freenet with /etc/init.d/freenet start."
	elog "2. Open localhost:8888 in your browser for the web interface."
	elog " "
	elog "If you dont know trusted people running freenet,"
	elog "enable opennet (\"insecure mode\") on the config page to get started."
	elog " "
	cp /opt/freenet/freenet-cvs-snapshot.jar /opt/freenet/freenet-stable-latest.jar && chown freenet:freenet /opt/freenet/freenet-stable-latest.jar
}

pkg_postrm() {
	elog "If you dont want to use freenet any more"
	elog "and dont want to keep your identity/other stuff"
	elog "remember to do 'rm -rf /opt/freenet' to remove everything"
}
