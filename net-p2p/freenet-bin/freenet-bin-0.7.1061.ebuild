# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_JAR_REV="r15122"
MY_JAR_FILE="freenet-${MY_JAR_REV}-snapshot.jar"

DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="http://downloads.freenetproject.org/alpha/installer/freenet07.tar.gz
	http://downloads.freenetproject.org/alpha/update/update.sh
	http://downloads.freenetproject.org/alpha/update/wrapper.conf
	http://downloads.freenetproject.org/alpha/${MY_JAR_FILE}
	http://dev.gentooexperimental.org/~tommy$/${MY_JAR_FILE}
	http://downloads.freenetproject.org/alpha/freenet-ext.jar"

LICENSE="GPL-2"
IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="!net-p2p/freenet
	>=virtual/jre-1.4"

S="${WORKDIR}/${PN/-bin/}"

RESTRICT="userpriv"

QA_TEXTRELS="opt/freenet/lib/libwrapper-linux-x86-32.so"

pkg_setup() {
	enewgroup freenet
	enewuser freenet -1 /bin/sh /opt/freenet freenet
}

src_unpack() {
	unpack "freenet07.tar.gz"
	cd "${S}"
	rm bin/wrapper-macosx* bin/wrapper-linux-ppc-* lib/libwrapper-macosx*.* \
		lib/libwrapper*ppc-*.so update stun mdns librarian bin/1run.sh bin/*jar \
		welcome.html INSTALL README

	sed -i -e 's:./bin/wrapper:/opt/freenet/bin/wrapper:g' \
		-e 's:./wrapper.conf:/opt/freenet/wrapper.conf:g' \
		-e 's:PIDDIR=".":PIDDIR="/opt/freenet/":g' \
		-e 's:#RUN_AS_USER=:RUN_AS_USER=freenet:g' run.sh || die "sed failed"
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	cd "${S}"
	newinitd run.sh freenet

	insinto /opt/freenet
	doins "${DISTDIR}/freenet-ext.jar" "${DISTDIR}/${MY_JAR_FILE}"
	doins "${DISTDIR}/update.sh" "${DISTDIR}/wrapper.conf"
	doins -r update.sh bin lib
	dosym freenet-stable-latest.jar /opt/freenet/freenet.jar
	fperms 755 /opt/freenet/bin/wrapper-linux-x86-{32,64}
	fowners -R freenet:freenet /opt/freenet/
}

pkg_postinst () {
	elog "1. Start freenet with /etc/init.d/freenet start"
	elog "2. Open localhost:8888 in your browser for the web interface."
	elog "3. After uninstalling freenet delete /opt/freenet manually (unless you want to keep it for a later reinstall)"
	elog "   as freenet creates some extra stuff not deleted by portage"

	if (diff /opt/freenet/${MY_JAR_FILE} /opt/freenet/freenet-stable-latest.jar >/dev/null 2>&1) ; then 
		:;
	else
		cp /opt/freenet/${MY_JAR_FILE} /opt/freenet/freenet-stable-latest.jar
	fi
}
