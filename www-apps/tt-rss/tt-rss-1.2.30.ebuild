# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils webapp depend.php depend.apache

DESCRIPTION="Tiny Tiny RSS - A web-based news feed (RSS/Atom) aggregator using AJAX"
HOMEPAGE="http://tt-rss.org/"
SRC_URI="http://tt-rss.org/download/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="mysql mysqli postgres"

need_httpd_cgi
need_php_httpd

pkg_setup() {
	local flag, activeflags=""
	for flag in ${IUSE};
	do
		use ${flag} && activeflags="${activeflags} ${flag}"
	done
	require_php_with_use ${activeflags}

	webapp_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Customize config.php so that the right 'DB_TYPE' is already set (according to the USE flag)
	einfo "Customizing config.php..."
	mv config.php{-dist,} || die "Could not rename config.php-dist to config.php."
	if ( use mysql || use mysqli ) && ! use postgres; then
		sed -e "/define('DB_TYPE',/{s:pgsql:mysql:}" -i config.php
	fi
	sed -e "/define('DB_TYPE',/{s:// \(or mysql\):// pgsql \1:}" -i config.php
}

src_install () {
	webapp_src_preinst

	insinto "/${MY_HTDOCSDIR}"
	doins -r * || die "Could not copy the files to ${MY_HTDOCSDIR}."
	keepdir "/${MY_HTDOCSDIR}"/icons

	webapp_serverowned "${MY_HTDOCSDIR}"/icons
	webapp_configfile "${MY_HTDOCSDIR}"/config.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
