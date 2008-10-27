# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
inherit eutils java-pkg-2 java-ant-2 multilib

DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="http://dev.gentooexperimental.org/~tommy/distfiles/${P}.tar.bz2
	http://dev.gentoo.org/~tommy/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="freemail"

CDEPEND="dev-db/db-je:3.3
	dev-java/fec
	dev-java/java-service-wrapper
	dev-java/db4o
	dev-java/ant-core"
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
	grep /opt/freenet /etc/passwd >/dev/null
	if [ $? == "0" ]; then
		ewarn " "
		ewarn "Changing freenet homedir from /opt/freenet to /var/freenet"
		ewarn " "
		usermod -d /var/freenet freenet || die "Was not able to change freenet homedir from /opt/freenet to /var/freenet"
	else
		enewuser freenet -1 -1 /var/freenet freenet
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}"/wrapper1.conf wrapper.conf
	epatch "${FILESDIR}"/ext.patch
	sed -i -e "s/=lib/=$(get_libdir)/g" wrapper.conf || die "sed failed"
	use freemail && echo "wrapper.java.classpath.7=/usr/share/bcprov/lib/bcprov.jar" >> wrapper.conf
	mkdir -p lib
	cd lib
	java-pkg_jar-from db-je-3.3
	java-pkg_jar-from java-service-wrapper
	java-pkg_jar-from fec
	java-pkg_jar-from db4o
	java-pkg_jar-from ant-core ant.jar
}

src_install() {
	mv lib/freenet-cvs-snapshot.jar freenet.jar
	java-pkg_dojar freenet.jar
	if has_version =sys-apps/baselayout-2*; then
		doinitd "${FILESDIR}"/freenet
	else
		newinitd "${FILESDIR}"/freenet.old freenet
	fi
	dodoc license/README license/LICENSE.Mantissa \
		AUTHORS README
	insinto /etc
	newins wrapper.conf freenet-wrapper.conf
	insinto /var/freenet
	doins seednodes.fref run.sh
	dodir /var/freenet/bin
	dodir /var/freenet/$(get_libdir)
	dosym ../../../usr/$(get_libdir)/java-service-wrapper/libwrapper.so /var/freenet/$(get_libdir)/libwrapper.so
	dosym ../../../usr/$(get_libdir)/libNativeThread.so /var/freenet/$(get_libdir)/libNativeThread.so
	use x86 && dosym ../../../usr/$(get_libdir)/libfec8.so /var/freenet/$(get_libdir)/libfec8.so
	use x86 && dosym ../../../usr/$(get_libdir)/libfec16.so /var/freenet/$(get_libdir)/libfec16.so
	fperms +x /var/freenet/run.sh
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
	if [[ -e /opt/freenet/freenet.ini ]] && ! [[ -e /var/freenet/freenet.ini ]]; then
		ewarn " "
		ewarn "Please move freenet to the new location with the following command:"
		ewarn "		mv /opt/freenet /var/freenet"
		ewarn " "
	fi
}

pkg_postrm() {
	if [ -z has_version ]; then
		elog "If you dont want to use freenet any more"
		elog "and dont want to keep your identity/other stuff"
		elog "remember to do 'rm -rf /var/freenet' to remove everything"
	fi
}
