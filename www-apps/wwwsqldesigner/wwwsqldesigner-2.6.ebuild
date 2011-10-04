# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit webapp

DESCRIPTION="Visual web-based SQL modelling tool"
HOMEPAGE="http://code.google.com/p/wwwsqldesigner/"
SRC_URI="http://wwwsqldesigner.googlecode.com/files/${P}.zip"

LICENSE="BSD-2"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/backend/php-{blank,cubrid,file,mysql,mysql+file,pdo,postgresql,sqlite}/index.php "${MY_HTDOCSDIR}"/backend/cf-mysql/index.cfm "${MY_HTDOCSDIR}"/backend/perl-file/index.pl "${MY_HTDOCSDIR}"/js/config.js

	webapp_src_install
}

pkg_postinst() {
	elog "To use server-side save/load functionality, you need to configure the"
	elog "respective storage backend(s)."
	elog "E.g. for php-mysql you need to import the table definition from"
	elog "backend/php-mysql/database.sql and enter connection credentials into"
	elog "backend/php-mysql/index.php"
	elog
	elog "For more information see http://code.google.com/p/wwwsqldesigner/w/list"
}
