# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator
MY_PV=$(replace_version_separator 3 '-')
S=${WORKDIR}/${PN}
INSTALLDIR="/opt/psybnc"

DESCRIPTION="PsyBNC is a multi-user and multi-server gateway to IRC networks"
HOMEPAGE="http://www.psybnc.at/index.html"
SRC_URI="http://www.psybnc.at/download/beta/psyBNC-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=dev-libs/openssl-0.9.7d"

pkg_setup() {
	enewgroup psybnc
	enewuser psybnc -1 -1 ${INSTALLDIR} psybnc
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PF}-gentoo.diff"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dodoc CHANGES FAQ README SCRIPTING TODO

	for dir in help key lang log motd scripts ; do
		dodir ${INSTALLDIR}/${dir}
		insinto ${INSTALLDIR}/${dir}
		doins ${dir}/*
	done

	insinto ${INSTALLDIR}
	doins "${FILESDIR}"/psybnc.conf config.h

	exeinto ${INSTALLDIR}
	doexe psybnc

	newinitd "${FILESDIR}"/psybnc.initd psybnc
	newconfd "${FILESDIR}"/psybnc.confd psybnc

	chown -R psybnc:psybnc "${D}"/${INSTALLDIR}
}

pkg_config() {
	einfo "Generating certificate request..."
	openssl req -new -out ${INSTALLDIR}/key/psybnc.req.pem -keyout ${INSTALLDIR}/key/psybnc.key.pem -nodes
	einfo "Generating self-signed certificate..."
	openssl req -x509 -days 365 -in ${INSTALLDIR}/key/psybnc.req.pem -key ${INSTALLDIR}/key/psybnc.key.pem -out ${INSTALLDIR}/key/psybnc.cert.pem
	einfo "Generating fingerprint..."
	openssl x509 -subject -dates -fingerprint -noout -in ${INSTALLDIR}/key/psybnc.cert.pem
}

pkg_postinst() {
	einfo ""
	einfo "Please run \"emerge --config =${CATEGORY}/${PF}\" to create SSL certificates for your system."
	einfo "You can connect to the bnc on port 23998, user=gentoo, pass=gentoo,"
	einfo "please edit the psybnc configuration in ${INSTALLDIR}/psybnc.conf to change this."
	einfo ""
}
