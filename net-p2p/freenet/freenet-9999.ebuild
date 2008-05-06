# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
DATE=20080506
DATE2=20080330
ESVN_REPO_URI="http://freenet.googlecode.com/svn/trunk/freenet"
ESVN_OPTIONS="--ignore-externals"
inherit eutils java-pkg-2 java-ant-2 subversion

DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="http://www.freenetproject.org/"
SRC_URI="http://dev.gentooexperimental.org/~tommy/seednodes-${DATE}.fref
	http://dev.gentooexperimental.org/~tommy/wrapper-${DATE2}.conf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/db-je:3.2
	dev-java/fec
	dev-java/java-service-wrapper"
DEPEND="dev-util/subversion
	>=dev-java/sun-jdk-1.4
	dev-java/ant-core
	dev-util/subversion
	${CDEPEND}"
RDEPEND="x86? ( >=virtual/jre-1.4 )
	amd64? ( >=virtual/jre-1.5 )
	x86? ( net-libs/fec )
	net-libs/nativebiginteger
	${CDEPEND}"
PDEPEND="net-libs/NativeThread"
S="${WORKDIR}/freenet"

RESTRICT="userpriv"
EANT_BUILD_TARGET="dist"
MY_FREENET_LATEST="-trunk"

pkg_setup() {
	enewgroup freenet
	enewuser freenet -1 -1 /opt/freenet freenet
}

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	svn -N co http://freenet.googlecode.com/svn/trunk/apps/new_installer/res/unix/ .
	cp "${DISTDIR}"/seednodes-${DATE}.fref seednodes.fref
	cp "${DISTDIR}"/wrapper-${DATE2}.conf wrapper.conf
	sed -i -e 's:./bin/wrapper:/opt/freenet/bin/wrapper:g' \
	-e 's:./wrapper.conf:/opt/freenet/wrapper.conf:g' \
	-e 's:PIDDIR=".":PIDDIR="/opt/freenet/":g' \
	-e 's:#RUN_AS_USER=:RUN_AS_USER=freenet:g' run.sh || die "sed failed"
	sed -ie "s:@custom@:${MY_FREENET_LATEST}:g" src/freenet/node/Version.java
	epatch "${FILESDIR}"/wrapper.conf.patch
	epatch "${FILESDIR}"/ext.patch
	use amd64 && sed -i -e 's/=lib/=lib64/g' wrapper.conf
	sed -i -e 's/=128/=2048/g' wrapper.conf
	mkdir -p lib
	cd lib
	java-pkg_jar-from db-je-3.2
	java-pkg_jar-from java-service-wrapper
	java-pkg_jar-from fec
}

src_compile() {
	#workaround for installed blackdown-jdk-1.4
	#freenet does not compile with it
	if has_version =dev-java/sun-jdk-1.4*; then
		GENTOO_VM="sun-jdk-1.4" java-pkg-2_src_compile
	elif has_version =dev-java/sun-jdk-1.5*; then
		GENTOO_VM="sun-jdk-1.5" java-pkg-2_src_compile
	elif has_version =dev-java/sun-jdk-1.6*; then
		GENTOO_VM="sun-jdk-1.6" java-pkg-2_src_compile
	fi
}

src_install() {
	mv lib/freenet-cvs-snapshot.jar freenet.jar
	java-pkg_dojar freenet.jar
	doinitd "${FILESDIR}"/freenet
	insinto /opt/freenet
	doins wrapper.conf run.sh seednodes.fref
	dodir /opt/freenet/bin
	dosym /usr/bin/wrapper /opt/freenet/bin/wrapper
	dodir /opt/freenet/$(get_libdir)
	dosym ../../../usr/$(get_libdir)/java-service-wrapper/libwrapper.so /opt/freenet/$(get_libdir)/libwrapper.so
	fperms +x /opt/freenet/run.sh
}

pkg_postinst () {
	elog "1. Start freenet with /etc/init.d/freenet start."
	elog "2. Open localhost:8888 in your browser for the web interface."
	elog
	elog "If you dont know trusted people running freenet,"
	elog "enable opennet (\"insecure mode\") on the config page to get started."
	elog
	if use amd64;then
		if has_version =dev-java/blackdown-jdk-1.4*;then
			elog "Freenet does not run with 64bit blackdown-jdk,"
			elog "please make sure that either system-vm or the"
			elog "user-vm for freenet uses sun-jdk or some other"
			elog "vm (other vms are untested)."
			elog
		fi
	fi
	chown freenet:freenet /opt/freenet
}

pkg_postrm() {
	elog "If you dont want to use freenet any more"
	elog "and dont want to keep your identity/other stuff"
	elog "remember to do 'rm -rf /opt/freenet' to remove everything"
}
