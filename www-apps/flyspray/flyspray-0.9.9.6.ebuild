# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

# we need webapp's default pkg_setup()
inherit eutils webapp

DESCRIPTION="An uncomplicated web-based bug tracking system"
HOMEPAGE="http://flyspray.org/"
SRC_URI="http://flyspray.org/${P}.zip"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64"
IUSE="graphviz"

# need_apache and friends not used because they aren't EAPI="2" friendly
DEPEND="app-arch/unzip"
RDEPEND="graphviz? ( media-gfx/graphviz )
	virtual/httpd-php:5.3
	|| ( =dev-lang/php-5.3*[mysql]
		=dev-lang/php-5.3*[mysqli]
		=dev-lang/php-5.3*[postgres] )
	dev-php/adodb"

src_prepare () {
	#http://bugs.flyspray.org/task/1617
	epatch "${FILESDIR}"/${P}-system-adodb.patch

	mv htaccess.dist .htaccess || die
	touch ${PN}.conf.php || die

	rm -r adodb || die "removing bundled dev-php/adodb"
}

src_install () {
	webapp_src_preinst

	dodoc docs/*.txt || die
	rm -r docs || die

	insinto "${MY_HTDOCSDIR}"
	doins -r . || die

	webapp_serverowned "${MY_HTDOCSDIR}"/{attachments,cache,${PN}.conf.php}
	webapp_configfile "${MY_HTDOCSDIR}"/{.htaccess,${PN}.conf.php}

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
