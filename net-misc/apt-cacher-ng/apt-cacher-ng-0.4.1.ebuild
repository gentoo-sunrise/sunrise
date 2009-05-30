# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PV=${PV%.*}
MY_DPV=${PV#*.*.}

DESCRIPTION="Yet another implementation of a HTTP proxy for Debian/Ubuntu software packages written in C++"
HOMEPAGE="http://www.unix-ag.uni-kl.de/~bloch/acng/"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/a/${PN}/${PN}_${MY_PV}-${MY_DPV}.diff.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc fuse"

DEPEND="app-arch/bzip2
	sys-libs/zlib"
RDEPEND="${DEPEND}
	dev-lang/perl
	fuse? ( sys-fs/fuse )"

S=${WORKDIR}/${PN}-${MY_PV}

pkg_setup() {
	# add new user & group for daemon
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_unpack() {
	unpack ${A}
	epatch "${WORKDIR}/${PN}_${MY_PV}-${MY_DPV}.diff" # Debian patchset number 1.2.3.x
	cd "${S}" && epatch "${FILESDIR}/${PN}-0.3.8-respect-portage-qa-build-unstripped.patch" # Respect portage
}

src_compile() {
	local build="acng"
	use fuse && build="${build} acngfs"
	# -j1 fix race noted in bug #265840 comment #5
	emake -j1 CURDIR="${S}" ${build} || die "make '${build}' failed!"
}

src_install() {
	# There is no any install target :(
	# So we do all stuff here

	dosbin apt-cacher-ng || die "Can't install apt-cacher-ng"
	if use fuse; then dobin acngfs || die "Can't install acngfs"; fi

	newinitd "${FILESDIR}"/initd ${PN} || die "Can't add new init.d ${PN}"
	newconfd "${FILESDIR}"/confd ${PN} || die "Can't add new conf.d ${PN}"

	# for logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/logrotate ${PN} || die "Can't install new file ${PN} into '/etc/logrotate.d'"

	doman doc/man/${PN}* || die "Can't install mans"
	if use fuse; then doman doc/man/acngfs* || die "Can't install man pages for fusefs"; fi

	# Documentation
	dodoc README TODO VERSION INSTALL ChangeLog || die "Can't install common docs"
	if use doc; then
		dodoc doc/*.pdf || die "Can't install docs"
		dohtml doc/html/* || die "Can't install html docs"
		docinto examples/conf
		dodoc conf/* || die "Can't install config examples"
	fi

	# perl daily cron script
	dosbin expire-caller.pl || die "Can't install cache cleaner perl script"
	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/cron.daily ${PN} || die "Can't install new daily cron script"

	# default configuration
	insinto /etc/${PN}
	newins conf/acng.conf ${PN}.conf || die "Can't install ${PN} configuration file"
	newins conf/report.html acng-report.html || die "Can't install ${PN} report page"

	# Some directories must exists
	keepdir /var/log/${PN}
	keepdir /var/run/${PN}
	fowners ${PN}:${PN} \
		/etc/${PN} \
		/etc/${PN}/${PN}.conf \
		/etc/${PN}/acng-report.html \
		/var/log/${PN} \
		/var/run/${PN} || die "Can't change owners"
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
