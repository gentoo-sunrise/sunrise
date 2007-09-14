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

DEPEND="!net-p2p/freenet-bin
	dev-java/sun-jdk
	dev-java/ant"
RDEPEND="virtual/jre"

S="${WORKDIR}/${PN}"
RESTRICT="userpriv"

QA_TEXTRELS="opt/freenet/lib/libwrapper-linux-x86-32.so"

pkg_setup() {
	# previous versions created a passwordless login for freenet user
	if has_version "<${CATEGORY}/${PN}-0.7.1061-r2" ; then
		eerror "Previous versions created user account with a passwordless login shell."
		eerror "You must unmerge the old version first and delete that user account."
		eerror "emerge -C \\<${CATEGORY}/${PN}-0.7.1061-r2; userdel freenet"
		die "Insecure version installed!"
	fi

	enewgroup freenet
	enewuser freenet -1 -1 /opt/freenet freenet
}

src_unpack() {
	unpack ${PN}07.tar.gz
	cd "${S}"
	unpack ${PN}-sources-v${MY_PV}.tar.bz2
}

src_compile() {
	cd contrib
	mkdir -p bdb/examples
	cd freenet_ext
	ant || die "freenet-ext failed"

	cd "${S}"/freenet
	mkdir -p lib
	cp "${S}"/contrib/freenet_ext/freenet-ext.jar lib/
	ant || die "freenet-stable-latest failed"

	sed -i -e 's:./bin/wrapper:/opt/freenet/bin/wrapper:g' \
		-e 's:./wrapper.conf:/opt/freenet/wrapper.conf:g' \
		-e 's:PIDDIR=".":PIDDIR="/opt/freenet/":g' \
		-e 's:#RUN_AS_USER=:RUN_AS_USER=freenet:g' "${S}"/run.sh || die "sed failed"
}

src_install() {
	doinitd "${FILESDIR}"/freenet
	insinto /opt/freenet
	into /opt/freenet

	dodoc license/README license/LICENSE.Mantissa license/LICENSE.Freenet
	dobin bin/wrapper-linux-x86-{32,64}
	dolib.so lib/libwrapper-linux-x86-{32,64}.so
	doins run.sh ${DISTDIR}/update.sh ${DISTDIR}/wrapper.conf freenet/lib/freenet-{cvs-snapshot,ext}.jar

	dosym freenet-stable-latest.jar /opt/freenet/freenet.jar
	fperms 755 /opt/freenet/{update,run}.sh
	fowners freenet:freenet /opt/freenet/ -R
}

pkg_postinst () {
	elog "1. Start freenet with /etc/init.d/freenet start"
	elog "2. Open localhost:8888 in your browser for the web interface."
	cp /opt/freenet/freenet-cvs-snapshot.jar /opt/freenet/freenet-stable-latest.jar && chown freenet:freenet /opt/freenet/*
}
