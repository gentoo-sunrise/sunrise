# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp depend.php

MY_P="${P}.${PR}"
DESCRIPTION="a component-based and event-driven web programming framework"
HOMEPAGE="http://www.pradosoft.com/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="BSD" # http://www.pradosoft.com/license/
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="virtual/httpd-cgi"

S=${WORKDIR}/${MY_P}

need_php5

src_install() {
	webapp_src_preinst

	dohtml -r docs/manual

	cp -r framework/* "${D}${MY_HTDOCSDIR}"
	cp framework/.htaccess "${D}${MY_HTDOCSDIR}"

	webapp_src_install
}
