# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_R1="14941"
MY_V="$(get_version_component_range 3)"
DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="http://downloads.freenetproject.org/alpha/installer/${PN}07.tar.gz
	http://downloads.freenetproject.org/alpha/update/update.sh
	http://downloads.freenetproject.org/alpha/update/wrapper.conf
	http://emu.freenetproject.org/sources/${PN}-sources-v${MY_V}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-java/sun-jdk
	dev-util/subversion
	dev-java/ant"
RDEPEND="virtual/jre"

S="${WORKDIR}/${PN}"
RESTRICT="userpriv mirror"

SVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/${PN}"
QA_TEXTRELS="opt/freenet/lib/libwrapper-linux-x86-32.so"

pkg_setup() {
enewgroup freenet
enewuser freenet -1 /bin/sh /opt/freenet freenet
}

src_unpack() {
	unpack ${PN}07.tar.gz
	cp "${DISTDIR}"/update.sh "${DISTDIR}"/wrapper.conf "${S}"/
	cd "${S}"
	rm bin/wrapper-macosx* bin/wrapper-linux-ppc-* lib/libwrapper-macosx*.* \
	lib/libwrapper*ppc-*.so update stun mdns librarian bin/1run.sh bin/*jar
	unpack ${PN}-sources-v${MY_V}.tar.gz
	addwrite "${SVN_STORE_DIR}"
	mkdir -p "${SVN_STORE_DIR}" || die "could not mkdir"
	cd "${SVN_STORE_DIR}" && cp "${FILESDIR}"/servers "${FILESDIR}"/freenet.pem .
	svn --config-dir . -r ${MY_R1} co https://emu.freenetproject.org/svn/trunk/contrib
	cp -R contrib "${S}"/
}

src_compile() {
	cd contrib
	sed -i -e "s:../bdb/lib/je.jar:../bdb/build/lib/je.jar:g" freenet_ext/build.xml
	sed -i -e "s:@custom@:${MY_R1}:g" freenet_ext/ExtVersion.java
	mkdir -p bdb/examples
	cd freenet_ext
	ant||die "freenet-ext failed"
	cd ../../${PN}-sources-${MY_V} && mkdir lib && cp ../contrib/freenet_ext/freenet-ext.jar lib/ && rm -R ../contrib
	ant|| die "freenet-stable-latest failed"
	cp lib/*.jar ../
	cd .. && rm -R ${PN}-sources-${MY_V}
	sed -i -e 's:./bin/wrapper:/opt/freenet/bin/wrapper:g' \
	-e 's:./wrapper.conf:/opt/freenet/wrapper.conf:g' \
	-e 's:PIDDIR=".":PIDDIR="/opt/freenet/":g' \
	-e 's:#RUN_AS_USER=:RUN_AS_USER=freenet:g' run.sh
}

src_install() {
	newinitd "${S}/run.sh" freenet1
	rm "${S}"/run.sh
	into /opt/freenet
	cp -R "${S}" "${D}/opt"
	dosym freenet-stable-latest.jar /opt/freenet/freenet.jar
	fowners freenet:freenet /opt/freenet/ -R
}

pkg_postinst () {
	einfo "2. Start freenet with /etc/init.d/freenet start"
	einfo "3. Open localhost:8888 in your browser for the web interface."
	cp /opt/freenet/freenet-cvs-snapshot.jar /opt/freenet/freenet-stable-latest.jar && chown freenet:freenet /opt/freenet/*
}

