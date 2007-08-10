## Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="http://www.freenetproject.org/"
MY_V="r14570"
MY_P="${PN/-bin/}-${MY_V}-snapshot.jar"
SRC_URI="http://downloads.freenetproject.org/alpha/installer/freenet07.tar.gz
	http://downloads.freenetproject.org/alpha/update/update.sh
	http://downloads.freenetproject.org/alpha/update/wrapper.conf
	http://downloads.freenetproject.org/alpha/${MY_P}
	http://downloads.freenetproject.org/alpha/freenet-ext.jar"
RESTRICT="userpriv mirror"
LICENSE="GPL-2"
IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="( >=virtual/jre-1.4 )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN/-bin/}"

QA_TEXTRELS="opt/freenet/lib/libwrapper-linux-x86-32.so
	opt/freenet/lib/libwrapper-linux-x86-64.so"

pkg_setup() {
enewgroup freenet
enewuser freenet -1 -1 /dev/null freenet
}

src_unpack() {
	unpack "freenet07.tar.gz"
	cp ${DISTDIR}/freenet-ext.jar ${DISTDIR}/update.sh ${DISTDIR}/wrapper.conf ${DISTDIR}/${MY_P} ${S}/
	cd "${S}"
	rm bin/wrapper-macosx* bin/wrapper-linux-ppc-* lib/libwrapper-macosx*.* \
	lib/libwrapper*ppc-*.so update stun mdns librarian bin/1run.sh bin/*jar
}

src_compile() {
	sed -e 's:./bin/wrapper:/opt/freenet/bin/wrapper:g' \
	-e 's:./wrapper.conf:/opt/freenet/wrapper.conf:g' \
	-e 's:PIDDIR=".":PIDDIR="/opt/freenet/":g' \
	-e 's:#RUN_AS_USER=:RUN_AS_USER=freenet:g' run.sh>freenet
	rm run.sh
}

src_install() {
	doinitd "${S}/freenet"
	rm ${S}/freenet
	into /opt/freenet
	cp -r ${S} ${D}/opt/
	dosym freenet-stable-latest.jar /opt/freenet/freenet.jar
	fowners freenet:freenet /opt/freenet/ -R
}

pkg_postinst () {
	einfo "1. Start freenet with /etc/init.d/freenet start"
	einfo "2. Open localhost:8888 in your browser for the web interface."
	einfo "3. After uninstalling freenet delete /opt/freenet manually (unless you want to keep it for a later reinstall)"
	einfo "   as freenet creates some extra stuff not deleted by portage"
	if (diff /opt/freenet/${MY_P} /opt/freenet/freenet-stable-latest.jar >/dev/null); then :;
	else
		cp /opt/freenet/${MY_P} /opt/freenet/freenet-stable-latest.jar
	fi
}
