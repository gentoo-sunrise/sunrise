# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit webapp depend.php

DESCRIPTION="amaroK Web Frontend"
HOMEPAGE="http://amarokwebfront.sourceforge.net/"
SRC_URI="mirror://sourceforge/amarokwebfront/${P}.tar.bz2"

KEYWORDS=""
LICENSE="GPL-2"
IUSE="mysql postgres"

DEPEND="dev-lang/php[mysql?,postgres?]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

need_php

src_install() {
	webapp_src_preinst

	local docs="README CHANGELOG"
	dodoc ${docs} || die "dodoc failed"
	rm -f ${docs} DISCLAIMER INSTALL LICENSE obsidianmusic.kateprj
	rm -r daemon

	insinto "${MY_HTDOCSDIR}"
	doins -r . || die "doins failed"
	webapp_serverowned "${MY_HTDOCSDIR}"/inc/cache
	webapp_configfile  "${MY_HTDOCSDIR}"/inc/config.php
	webapp_configfile  "${MY_HTDOCSDIR}"/inc/auth.users.php

	webapp_src_install
}
