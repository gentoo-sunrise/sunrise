# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A multi-purpose wrapper plugin for Nagios"
HOMEPAGE="http://my-plugin.de/wiki/projects/check_multi/start"
SRC_URI="http://my-plugin.de/check_multi/check_multi-stable-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	net-analyzer/nagios-plugins"

S=${WORKDIR}/check_multi-${PV}

src_compile() {
	econf \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--sysconfdir=/etc/nagios \
		--with-nagios-group=nagios

	emake all || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install install-config || die "emake install failed"

	# set file permissions similar to nagios / nagios-plugins
	fperms 0750 /usr/$(get_libdir)/nagios/plugins/check_multi \
		|| die "Failed chmod of ${D}usr/$(get_libdir)/nagios/plugins/check_multi"

	# the files in this directory have been incorrectly set executable permissions
	# by the author. Author said that will be corrected in next version.
	find "${D}"/etc/nagios/check_multi -type f -exec chmod 0640 {} \;

	dodoc README Changelog  || die "dodoc failed"
}

pkg_postinst() {
	elog "Check ${ROOT}/etc/nagios/check_multi for config examples."
	elog "In case ${PN} is to be used with net-analyzer/nagios-nrpe"
	elog "make sure that it is version 2.12-r103 or greater on both"
	elog "the client and the server sides (see bug #264467)."
}
