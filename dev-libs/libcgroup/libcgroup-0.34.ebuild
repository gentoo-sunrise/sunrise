# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools linux-info pam

DESCRIPTION="Tools and libraries to control and monitor control groups"
HOMEPAGE="http://libcg.sourceforge.net/"
SRC_URI="mirror://sourceforge/libcg/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="+daemon debug pam static-libs +tools"

RDEPEND="pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	if use daemon && ! use tools; then
		eerror "The daemon USE flag requires tools USE flag."
		die "Please enable tools or disable daemon."
	fi

	local CONFIG_CHECK="~CGROUPS"
	if use daemon; then
		CONFIG_CHECK="${CONFIG_CHECK} ~CONNECTOR ~PROC_EVENTS"
	fi
	linux-info_pkg_setup
}

src_prepare() {
	# Change rules file location
	sed -e 's:/etc/cgrules.conf:/etc/cgroup/cgrules.conf:' \
		-i src/libcgroup-internal.h || die "sed failed"

	# Install PAM module into correct location
	sed \
		-e "/lib_LTLIBRARIES/ i pamlibdir=$(getpam_mod_dir)" \
		-e 's/lib_LTLIBRARIES/pamlib_LTLIBRARIES/' \
		-e '/pam_cgroup_la_LDFLAGS/ s/$/ -avoid-version -shared/' \
		-i src/pam/Makefile.am || die "sed failed"

	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable daemon) \
		$(use_enable debug) \
		$(use_enable pam) \
		$(use_enable static-libs static) \
		$(use_enable tools)
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	find "${D}" -name "*.la" -delete || die "la removal failed"

	insinto /etc/cgroup
	doins samples/cgrules.conf || die

	if use tools; then
		doins samples/cgconfig.conf || die

		newconfd "${FILESDIR}"/cgconfig.confd cgconfig || die
		newinitd "${FILESDIR}"/cgconfig.initd cgconfig || die
	fi

	if use daemon; then
		newconfd "${FILESDIR}"/cgred.confd cgred || die
		newinitd "${FILESDIR}"/cgred.initd cgred || die
	fi
}
