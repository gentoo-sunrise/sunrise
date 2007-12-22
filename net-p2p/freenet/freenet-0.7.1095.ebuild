# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PV="$(get_version_component_range 3)"
DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="http://dev.gentooexperimental.org/~tommy/${PN}-sources-v${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="!net-p2p/freenet-bin
	dev-java/sun-jdk
	dev-java/ant"
RDEPEND="virtual/jre"

S="${WORKDIR}/${PN}"

QA_TEXTRELS="opt/freenet/lib/libwrapper-linux-x86-32.so"

pkg_setup() {
	enewgroup freenet
	enewuser freenet -1 -1 /opt/freenet freenet
}

src_compile() {
	echo "node.updater.autoupdate=false" > freenet.ini
	cd contrib
	mkdir -p bdb/examples
	cd freenet_ext
	ant || die "freenet-ext failed"

	cd "${S}"/freenet
	mkdir -p lib
	cp "${S}"/contrib/freenet_ext/freenet-ext.jar lib/
	ant || die "freenet-stable-latest failed"
}

src_install() {
	doinitd "${FILESDIR}"/freenet
	insinto /opt/freenet
	into /opt/freenet

	dodoc license/README license/LICENSE.Mantissa license/LICENSE.Freenet
	dobin bin/wrapper-linux-x86-{32,64}
	dolib.so lib/libwrapper-linux-x86-{32,64}.so
	doins seednodes.fref freenet.ini run.sh "${S}"/update.sh \
		"${S}"/wrapper.conf freenet/lib/freenet-{cvs-snapshot,ext}.jar

	dosym freenet-stable-latest.jar /opt/freenet/freenet.jar
	fperms 755 /opt/freenet/{update,run}.sh
	fowners freenet:freenet /opt/freenet/ -R
}

pkg_postinst () {
	elog "1. Start freenet with /etc/init.d/freenet start."
	elog "2. Open localhost:8888 in your browser for the web interface."
	cp /opt/freenet/freenet-cvs-snapshot.jar /opt/freenet/freenet-stable-latest.jar && chown freenet:freenet /opt/freenet/*
}

pkg_postrm() {
	elog "If you dont want to use freenet any more"
	elog "and dont want to keep your identity/other stuff"
	elog "remember to do 'rm -rf /opt/freenet' to remove everything"
}

