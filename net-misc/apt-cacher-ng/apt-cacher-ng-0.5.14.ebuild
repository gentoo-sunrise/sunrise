# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit cmake-utils eutils

DESCRIPTION="Yet another implementation of a HTTP proxy for Debian/Ubuntu software packages written in C++"
HOMEPAGE="http://www.unix-ag.uni-kl.de/~bloch/acng/"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples fuse lzma"

DEPEND="app-arch/bzip2
	sys-libs/zlib
	lzma? (
		|| ( app-arch/xz-utils
			app-arch/lzma-utils )
	)"
RDEPEND="${DEPEND}
	dev-lang/perl
	fuse? ( sys-fs/fuse )"

pkg_setup() {
	# Add a new user & group for the daemon.
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_configure() {
	mycmakeargs=(
		# avoid forcing in LDFLAGS
		-DHAVE_WL_AS_NEEDED=OFF
		# assert for possible boost automagic
		-DHAVE_BOOST_SMARTPTR=OFF

		$(cmake-utils_use_has lzma LZMA)
		$(cmake-utils_use_has fuse FUSE_26)
	)

	cmake-utils_src_configure
}

src_install() {
	dosbin "${CMAKE_BUILD_DIR}"/${PN} || die
	doman doc/man/${PN}.8 || die
	if use fuse; then
		dobin "${CMAKE_BUILD_DIR}"/acngfs || die
		doman doc/man/acngfs.8 || die
	fi

	newinitd "${FILESDIR}"/initd ${PN} || die
	newconfd "${FILESDIR}"/confd ${PN} || die

	# for logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/logrotate ${PN} || die

	# Documentation
	dodoc ChangeLog doc/README TODO || die
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
