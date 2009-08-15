# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils java-pkg-2 java-ant-2

MY_P="gt${PV}-all-source-installer"

DESCRIPTION="The Globus Toolkit - grid middleware package"
HOMEPAGE="http://www.globus.org/toolkit/"

SRC_URI="http://www-unix.globus.org/ftppub/gt${PV:0:1}/${PV}/installers/src/${MY_P}.tar.bz2"

LICENSE="GTPL"

SLOT="4"
KEYWORDS="~x86"

# The original build system does not build the following USE
# controlled components by default (i18n prews wsjava wsc wsdel wsrft
# wscas wsctests).  You may turn them off as you wish...
IUSE="condor +gridftp +gridway i18n iodbc lsf odbc pbs prews
	  +prews-test +prewsgram +rls wsc wscas wsctests wsdel
	  +wsgram wsjava +wsmds wsrft +wstests"

COMMON_DEP="
	dev-java/ant
	sys-libs/zlib
	dev-lang/perl
	app-admin/sudo
	dev-libs/openssl
	dev-db/postgresql
	dev-perl/XML-Parser
	virtual/mpi
	=sys-cluster/globus-build-${PV}
	iodbc? ( dev-db/libiodbc )
	odbc? ( !iodbc? ( dev-db/unixODBC ) )"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

GLOBUS="/opt/globus${PV:0:1}"

src_prepare() {
	mkdir "${S}"/build || die "making build directory failed"

	# Do not build the globus-build tools by default (in this case it is
	# supplied with sci-physics/globus-build)
	sed -e "s|: gpt|:|" \
		-i Makefile.in || die "sed Makefile.in failed"

	# Fixing RLS so it can find sql.h etc..."
	sed -e 's?DEFAULT_INCLUDES = -I.?& -I/usr/include/iodbc?' \
		-i source-trees/replica/rls/server/Makefile.in \
				|| die "sed RLS Makefile.in failed"

	# apply patches
	epatch "${FILESDIR}"/gwd_open.patch
	epatch "${FILESDIR}"/gaa_test.patch

	sed -e "s|%%GLOBUS%%|${GLOBUS}|" \
		"${FILESDIR}"/22globus > "${T}"/22globus \
			|| die "sed envfile failed"
}

src_configure() {
	local myconfig

	# should we use odbc with iodbc or unixodbc
	if use iodbc ; then
		myconfig="--with-iodbc-libs=$(iodbc-config --prefix)/lib"
		myconfig="${myconfig} --with-iodbc-includes=$(iodbc-config --prefix)/include/iodbc"
	elif use odbc ; then
		myconfig="--with-unixodbc-libs=/usr/lib"
		myconfig="${myconfig} --with-unixodbc-includes=/usr/include/unixodbc"
	fi

	java-pkg_switch-vm

	econf --prefix="${S}/build/${GLOBUS}" \
		  --with-gptlocation=${GLOBUS} \
		  $(use_enable condor wsgram-condor) \
		  $(use_enable lsf wsgram-lsf) \
		  $(use_enable pbs wsgram-pbs) ${myconfig}
}

src_compile() {
	# Build these basic components always, then the individual
	# components can be built as desired (controlled by the USE flags
	# above).  The initial components must always be built in order
	# to build some of the optional ones (ORDER MATTERS).
	local mycomponents="gsi-myproxy gsi-openssh gt4-java-ws-core gt4-java-admin gt4-mds gt4-delegation gt4-rft gt4-cas gt4-c-ws-core prews-test globus-gsi-test gt4-replicator gt4-replication-client globus_rendezvous"

	# These components are built as part of the original "all:"
	# target.  The project INSTALL file specifies that the desired
	# behaviour is to allow building of individual components without
	# building the entire system.  Therefore, these should be
	# optional, but ON by default.
	mycomponents="${mycomponents} $(use gridftp    && echo gridftp)"
	mycomponents="${mycomponents} $(use prewsgram  && echo prewsgram)"
	mycomponents="${mycomponents} $(use rls        && echo rls)"
	mycomponents="${mycomponents} $(use wsgram     && echo wsgram)"
	mycomponents="${mycomponents} $(use wsmds      && echo wsmds)"
	mycomponents="${mycomponents} $(use prews-test && echo prews-test)"
	mycomponents="${mycomponents} $(use wstests    && echo wstests)"
	mycomponents="${mycomponents} $(use gridway    && echo gridway)"

	# These components are strictly optional, and are turned OFF
	# default in the IUSE flags.
	mycomponents="${mycomponents} $(use i18n       && echo i18n)"
	mycomponents="${mycomponents} $(use prews      && echo prews)"
	mycomponents="${mycomponents} $(use wsjava     && echo wsjava)"
	mycomponents="${mycomponents} $(use wsc        && echo wsc)"
	mycomponents="${mycomponents} $(use wsdel      && echo wsdel)"
	mycomponents="${mycomponents} $(use wsrft      && echo wsrft)"
	mycomponents="${mycomponents} $(use wscas      && echo wscas)"
	mycomponents="${mycomponents} $(use wsctests   && echo wsctests)"

	einfo
	einfo "Making components = ${mycomponents}"
	einfo
	emake -j1 ${mycomponents} || die "make failed!"
}

src_install() {
	einfo "Hand installing..."
	# The supplied Makefile install violates standard practices.  The
	# following simulates a "make DESTDIR=${D}" and moves the built
	# programs/files into ${D}
	mv build/* "${D}/" || die "mv failed"

	doenvd "${T}"/22globus || die "install env.d/globus died"
	newinitd "${FILESDIR}"/${PN}-init.d globus \
		|| die "install env.d/globus died"

	insinto "${GLOBUS}/share/extras"
	doins quickstart.html || die "install quickstart.html died"

	einfo "linking globus_packages directory"
	dosym "${ROOT}${GLOBUS}"/etc/gpt/packages \
		  "${ROOT}${GLOBUS}"/etc/globus_packages \
			|| die "generating symbolic link died"

	einfo "Updating ownership and permissions..."
	fowners -R globus:globus ${GLOBUS} || die "fowners failed"
}

pkg_postinst() {
	# The Makefile provided with the package does not respect
	# DESTDIR=${D}, or conventional installs for that matter, and
	# builds directly into the installation directories
	# (i.e. /${GLOBUS}) thus generating access violations.  In
	# addition, pkg_postinst assumes that you are done with ${S} so
	# we (re)implement the postinstall phase of the package here so
	# that any assumptions inherent in the Makefile are ignored.
	einfo "running gpt-postinstall"
	GLOBUS_LOCATION="${ROOT}${GLOBUS}" GPT_LOCATION="${ROOT}${GLOBUS}" \
		"${ROOT}${GLOBUS}"/sbin/gpt-postinstall || die "gpt-postinstall failed"

	elog "If you wish to configure the optional GAA-based Globus"
	elog "Authorization callouts, run thesetup-globus-gaa-authz-callout"
	elog "setup script."
	elog
	elog "You will have to install a cert file (eg. /etc/grid-security/hostcert.pem)"
	elog "and then re-run setup-globus-gram-job-manager."
}

pkg_postrm() {
	if [ -z has_version ]; then
		ewarn "Globus builds and installs files into ${GLOBUS}"
		ewarn "after package installation.  After uninstalling"
		ewarn "you may want to manually remove all or part of the Globus"
		ewarn "installation directory ${GLOBUS}."
	fi
}
