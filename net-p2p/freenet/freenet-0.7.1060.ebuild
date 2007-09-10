# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PV="$(get_version_component_range 3)"
DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="http://downloads.freenetproject.org/alpha/installer/${PN}07.tar.gz
	http://downloads.freenetproject.org/alpha/update/update.sh
	http://downloads.freenetproject.org/alpha/update/wrapper.conf
	http://dev.gentooexperimental.org/~tommy/${PN}-sources-v${MY_PV}.tar.bz2
	http://www.tommyserver.de/mirrors/${PN}-sources-v${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="userpriv mirror"

DEPEND="!net-p2p/freenet-bin
	dev-java/sun-jdk
	dev-java/ant"
RDEPEND="virtual/jre"

S="${WORKDIR}/${PN}"

QA_TEXTRELS="opt/freenet/lib/libwrapper-linux-x86-32.so"

pkg_setup() {
enewgroup freenet
enewuser freenet -1 /bin/sh /opt/freenet freenet
}

src_unpack() {
	unpack ${PN}07.tar.gz
	cd "${S}"
	rm bin/wrapper-macosx* bin/wrapper-linux-ppc-* lib/libwrapper-macosx*.* \
	lib/libwrapper*ppc-*.so update stun mdns librarian bin/1run.sh bin/*jar \
	welcome.html INSTALL README
	unpack ${PN}-sources-v${MY_PV}.tar.bz2
}

src_compile() {
	cd contrib
	mkdir -p bdb/examples
	cd freenet_ext
	ant||die "freenet-ext failed"
	cd ../../${PN} && mkdir lib && cp ../contrib/freenet_ext/freenet-ext.jar lib/ && rm -R ../contrib
	ant|| die "freenet-stable-latest failed"
	cp lib/*.jar ../
	cd .. && rm -R ${PN}
	sed -i -e 's:./bin/wrapper:/opt/freenet/bin/wrapper:g' \
	-e 's:./wrapper.conf:/opt/freenet/wrapper.conf:g' \
	-e 's:PIDDIR=".":PIDDIR="/opt/freenet/":g' \
	-e 's:#RUN_AS_USER=:RUN_AS_USER=freenet:g' run.sh
}

src_install() {
	newinitd "${S}/run.sh" freenet1
	rm "${S}"/run.sh
	insinto /opt/freenet
	doins -r bin freenet-cvs-snapshot.jar freenet-ext.jar lib license ${DISTDIR}/update.sh ${DISTDIR}/wrapper.conf
	fperms 755 /opt/freenet/bin/wrapper-linux-x86-{32,64}
	dosym freenet-stable-latest.jar /opt/freenet/freenet.jar
	fowners freenet:freenet /opt/freenet/ -R
}

pkg_postinst () {
	einfo "2. Start freenet with /etc/init.d/freenet start"
	einfo "3. Open localhost:8888 in your browser for the web interface."
	cp /opt/freenet/freenet-cvs-snapshot.jar /opt/freenet/freenet-stable-latest.jar && chown freenet:freenet /opt/freenet/*
}

