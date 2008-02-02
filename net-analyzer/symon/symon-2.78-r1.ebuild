# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit depend.php eutils toolchain-funcs webapp

DESCRIPTION="A system monitor that can be used to obtain accurate and up to date information on the performance of a number of systems"
HOMEPAGE="http://www.xs4all.nl/~wpd/symon/"
SRC_URI="http://www.xs4all.nl/~wpd/symon/philes/${P}.tar.gz
	syweb? ( http://www.xs4all.nl/~wpd/symon/philes/syweb-0.57.tar.gz )"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="symux syweb"

DEPEND="symux? ( net-analyzer/rrdtool )
	sys-devel/pmake"
RDEPEND="symux? ( net-analyzer/rrdtool )
	syweb? ( virtual/httpd-php )"

S=${WORKDIR}/${PN}
WEBAPP_MANUAL_SLOT="yes"

pkg_setup() {
	if use syweb ; then
		require_php_with_use gd
		webapp_pkg_setup
	fi
}

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/${PN}-symon.conf.patch
	use symux && epatch "${FILESDIR}"/${PN}-symux.conf.patch

	if use syweb ; then
		epatch "${FILESDIR}"/${PN}-syweb-class_lexer.inc.patch
		epatch "${FILESDIR}"/${PN}-syweb-setup.inc.patch
		epatch "${FILESDIR}"/${PN}-syweb-total_firewall.layout.patch
	fi

	! use symux && sed -i -e "/SUBDIR/ s/symux//" "${S}"/Makefile
	sed -i -e "s:CFLAGS+=-Wall:CFLAGS=${CFLAGS}:" "${S}"/Makefile.inc
}

src_compile() {
	MAKE=pmake emake CC="$(tc-getCC)" STRIP=true || die "emake failed."
}

src_install() {
	insinto /etc
	doins symon/symon.conf

	newinitd "${FILESDIR}"/${PN}-init.d ${PN} || die "newinitd failed."

	dodoc CHANGELOG HACKERS TODO

	doman symon/symon.8
	dosbin symon/symon

	dodir /usr/share/symon
	insinto /usr/share/symon
	doins symon/c_config.sh
	fperms a+x,u-w /usr/share/symon/c_config.sh

	if use symux ; then
		insinto /etc
		doins symux/symux.conf

		newinitd "${FILESDIR}"/symux-init.d symux || die "newinitd failed."

		doman symux/symux.8
		dosbin symux/symux

		insinto /usr/share/symon
		doins symux/c_smrrds.sh
		fperms u-w,u+x /usr/share/symon/c_smrrds.sh

		dodir /var/lib/symon/rrds/localhost
	fi

	if use syweb ; then
		docinto /layouts
		dodoc "${WORKDIR}"/syweb/symon/total_firewall.layout

		webapp_src_preinst

		dodir "${MY_HTDOCSDIR}"/cache
		dodir "${MY_HTDOCSDIR}"/layouts
		webapp_serverowned "${MY_HTDOCSDIR}"/cache
		insinto "${MY_HTDOCSDIR}"
		doins -r "${WORKDIR}"/syweb/htdocs/syweb/*
		webapp_configfile "${MY_HTDOCSDIR}"/setup.inc

		webapp_src_install
	fi
}

pkg_postinst() {
	if use syweb ; then
		elog "Test your syweb configuration by pointing your browser at:"
		elog "http://${VHOST_HOSTNAME}/${PN}/configtest.php"
		webapp_pkg_postinst
	fi

	elog "You'll need to setup your /etc/symon.conf and "
	elog "/etc/symux.conf before running these daemons for "
	elog "the first time."
	elog "For an example configuration run /usr/share/symon/c_config.sh"
	elog "Then, you may run /usr/share/symon/c_smrrds.sh all"
	elog "To test the configuration run sym{on,ux} -t"
	elog "For details, please see their manpages."
	elog "NOTE that symon won't chroot by default."
}
