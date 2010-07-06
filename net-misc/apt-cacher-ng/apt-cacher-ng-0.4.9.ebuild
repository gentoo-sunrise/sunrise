# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

PATCHSET_V=1
DESCRIPTION="Yet another implementation of a HTTP proxy for Debian/Ubuntu software packages written in C++"
HOMEPAGE="http://www.unix-ag.uni-kl.de/~bloch/acng/"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples fuse logrotate"

DEPEND="app-arch/bzip2
	sys-libs/zlib"
RDEPEND="${DEPEND}
	dev-lang/perl
	fuse? ( sys-fs/fuse )"

pkg_setup() {
	# Add a new user & group for the daemon.
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	# Respect our LDFLAGS for all targets.
	sed -i \
		-e 's:\($(CXX)\)\(.*\)-Wl,--as-needed:\1 $(LDFLAGS)\2:' \
		Makefile || die
}

src_compile() {
	tc-export CXX
	local build=
	use fuse && build=acngfs
	emake CURDIR="${S}" acng ${build} || die
}

src_install() {
	dosbin ${PN} || die
	doman doc/man/${PN}.8 || die
	if use fuse; then
		dobin acngfs || die
		doman doc/man/acngfs.8 || die
	fi

	newinitd "${FILESDIR}"/initd ${PN} || die
	newconfd "${FILESDIR}"/confd ${PN} || die

	# for logrotate
	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/logrotate ${PN} || die
	fi

	# Documentation
	dodoc ChangeLog README TODO || die
	if use doc; then
		dodoc doc/*.pdf || die
		dohtml doc/html/* || die
	fi

	if use examples; then
		docinto example
		dodoc conf/* || die
	fi

	# perl daily cron script
	dosbin expire-caller.pl || die
	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/cron.daily ${PN} || die

	# default configuration
	insinto /etc/${PN}
	newins conf/acng.conf ${PN}.conf || die
	newins conf/report.html acng-report.html || die

	# Some directories must exist
	keepdir /var/log/${PN}
	keepdir /var/run/${PN}

	fowners ${PN}:${PN} \
		/etc/${PN} \
		/etc/${PN}/${PN}.conf \
		/etc/${PN}/acng-report.html \
		/var/log/${PN} \
		/var/run/${PN} || die
}

pkg_postinst() {
	elog "Do not forget about edit configuration file and read manuals!"
	elog "   Default file : /etc/${PN}/${PN}.conf"
	elog "   Manual page  : man 8 apt-cache-ng"
	elog "   Documentation: /usr/share/doc/${PF}"
	if use fuse; then
		elog "You have choose to build fuse httpfs named 'acngfs'."
		elog "It's can be used to mount apt cache on server to client"
		elog "filesystem."
		elog "   Manual page  : man 8 acngfs"
	fi
	elog "Please note: this ebuild installs /etc/cron.daily/${PN} cron job."
}
