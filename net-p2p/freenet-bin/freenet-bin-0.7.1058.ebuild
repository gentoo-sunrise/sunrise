# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_JAR_REV="r14996"
MY_JAR_FILE="freenet-${MY_JAR_REV}-snapshot.jar"

DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="http://downloads.freenetproject.org/alpha/installer/freenet07.tar.gz
	http://downloads.freenetproject.org/alpha/update/update.sh
	http://downloads.freenetproject.org/alpha/update/wrapper.conf
	http://downloads.freenetproject.org/alpha/${MY_JAR_FILE}
	http://www.tommyserver.de/mirrors/${MY_JAR_FILE}
	http://downloads.freenetproject.org/alpha/freenet-ext.jar"

LICENSE="GPL-2"
IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${PN/-bin/}"

RESTRICT="userpriv mirror"

QA_TEXTRELS="opt/freenet/lib/libwrapper-linux-x86-32.so
	opt/freenet/lib/libwrapper-linux-x86-64.so"

pkg_setup() {
	enewgroup freenet
	enewuser freenet -1 /bin/sh /opt/freenet freenet
}

src_unpack() {
	unpack "freenet07.tar.gz"
	cd "${S}"
	rm bin/wrapper-macosx* bin/wrapper-linux-ppc-* lib/libwrapper-macosx*.* \
	lib/libwrapper*ppc-*.so update stun mdns librarian bin/1run.sh bin/*jar
	sed -ie 's:./bin/wrapper:/opt/freenet/bin/wrapper:g' run.sh
	sed -ie 's:./wrapper.conf:/opt/freenet/wrapper.conf:g' run.sh
	sed -ie 's:PIDDIR=".":PIDDIR="/opt/freenet/":g' run.sh
	sed -ie 's:#RUN_AS_USER=:RUN_AS_USER=freenet:g' run.sh
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	cd "${S}"
	newinitd run.sh freenet

	dodoc INSTALL README 

	insinto /opt/freenet
	doins ${DISTDIR}/freenet-ext.jar ${DISTDIR}/${MY_JAR_FILE}
	doins ${DISTDIR}/update.sh ${DISTDIR}/wrapper.conf 
	doins -r welcome.html run.she update.sh bin lib
	newins ${DISTDIR}/${MY_JAR_FILE} freenet-stable-latest.jar
	dosym freenet-stable-latest.jar /opt/freenet/freenet.jar
	fperms 755 /opt/freenet/bin/wrapper-linux-x86-{32,64}
	fperms 755 /opt/freenet/{run.she,update.sh}
	fowners -R freenet:freenet /opt/freenet/
}

pkg_postinst () {
	einfo "1. Start freenet with /etc/init.d/freenet start"
	einfo "2. Open localhost:8888 in your browser for the web interface."
	einfo "3. After uninstalling freenet delete /opt/freenet manually (unless you want to keep it for a later reinstall)"
	einfo "   as freenet creates some extra stuff not deleted by portage"
}
