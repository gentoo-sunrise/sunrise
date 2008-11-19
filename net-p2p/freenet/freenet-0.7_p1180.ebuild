# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
inherit eutils java-pkg-2 java-ant-2 multilib

DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="http://dev.gentooexperimental.org/~tommy/distfiles/${P}.tar.bz2
	http://dev.gentoo.org/~tommy/distfiles/${P}.tar.bz2"

LICENSE="as-is GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="freemail"

CDEPEND="dev-db/db-je:3.3
	dev-java/fec
	dev-java/java-service-wrapper
	dev-java/db4o
	dev-java/ant-core
	dev-java/sevenzip
	dev-java/lzmajio
	dev-java/mersennetwister"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
	x86? ( net-libs/fec )
	net-libs/nativebiginteger
	${CDEPEND}"
PDEPEND="net-libs/NativeThread
	freemail? ( dev-java/bcprov
		net-mail/Freemail )"
S="${WORKDIR}/${PN}"

EANT_BUILD_TARGET="dist"

pkg_setup() {
	java-pkg-2_pkg_setup
	enewgroup freenet
	enewuser freenet -1 -1 /var/freenet freenet
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}"/wrapper1.conf wrapper.conf
	epatch "${FILESDIR}"/ext.patch
	sed -i -e "s:=/usr/lib:=/usr/$(get_libdir):g" wrapper.conf || die "sed failed"
	use freemail && echo "wrapper.java.classpath.10=/usr/share/bcprov/lib/bcprov.jar" >> wrapper.conf
	mkdir -p lib
	cd lib
	java-pkg_jar-from db-je-3.3
	java-pkg_jar-from java-service-wrapper
	java-pkg_jar-from fec
	java-pkg_jar-from db4o
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from sevenzip
	java-pkg_jar-from lzmajio
	java-pkg_jar-from mersennetwister
}

src_install() {
	mv lib/freenet-cvs-snapshot.jar freenet.jar
	java-pkg_dojar freenet.jar
	if has_version =sys-apps/baselayout-2*; then
		doinitd "${FILESDIR}"/freenet
	else
		newinitd "${FILESDIR}"/freenet.old freenet
	fi
	dodoc AUTHORS README
	insinto /etc
	newins wrapper.conf freenet-wrapper.conf
	insinto /var/freenet
	doins seednodes.fref run.sh
	fperms +x /var/freenet/run.sh
	dosym java-service-wrapper/libwrapper.so /usr/$(get_libdir)/libwrapper.so
}

pkg_postinst () {
	elog "1. Start freenet with /etc/init.d/freenet start."
	elog "2. Open localhost:8888 in your browser for the web interface."
	elog " "
	elog "If you dont know trusted people running freenet,"
	elog "enable opennet (\"insecure mode\") on the config page to get started."
	elog " "
	ewarn "The wrapper config file wrapper.conf has been moved to /etc/freenet-wrapper.conf."
	ewarn "You can now edit it without the next update overwriting it."
	elog " "
	chown freenet:freenet /var/freenet
}

pkg_postrm() {
	if [ -z has_version ]; then
		elog "If you dont want to use freenet any more"
		elog "and dont want to keep your identity/other stuff"
		elog "remember to do 'rm -rf /var/freenet' to remove everything"
	fi
}
