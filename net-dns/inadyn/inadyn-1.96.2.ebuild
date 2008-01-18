# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Dyndns client in C supporting various services"
HOMEPAGE="http://inadyn.ina-tech.net/"
SRC_URI="http://inadyn.ina-tech.net/${PN}.v${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/${PN}

pkg_setup() {
	enewuser inadyn -1 -1 -1
}

src_install() {
	dosbin bin/linux/inadyn
	doman man/*
	dohtml readme.html

	newinitd "${FILESDIR}"/inadyn.initd inadyn

	insinto /etc
	doins "${FILESDIR}"/inadyn.conf
}

pkg_postinst() {
	elog "You will need to edit /etc/inadyn.conf file before"
	elog "running inadyn for the firt time. The file is basically"
	elog "command line options; see inadyn and inayn.conf manpages."
}
