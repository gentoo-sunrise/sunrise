# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit webapp

DESCRIPTION="The Ajax CMS for today. And tomorrow."
HOMEPAGE="http://www.modxcms.com/"
SRC_URI="http://www.modxcms.com/assets/snippets/filedownload/download.php?path=YnVpbGRz&fileName=${P}.tar.gz
-> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/httpd-cgi
	>=virtual/mysql-4.1
	|| ( dev-lang/php:5[mysql] dev-lang/php:5[mysqli] )"

src_install() {
	webapp_src_preinst
	find . -iname ht.access -execdir mv '{}' .htaccess \; || die "Dot fix failed"
	insinto ${MY_HTDOCSDIR}
	doins -r . || die "Instalation failed"
	webapp_src_install
}
