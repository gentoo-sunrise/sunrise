# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_P="monitor"

DESCRIPTION="Monitoring application for www-servers/hiawatha"
HOMEPAGE="http://www.hiawatha-webserver.org/howto/monitor"
SRC_URI="http://www.hiawatha-webserver.org/files/${MY_P}-${PV}.tar.gz "

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	www-servers/hiawatha[xsl]
	virtual/cron
	=dev-lang/php-5*[mysql,xsl]
	virtual/mysql"

S=${WORKDIR}/${MY_P}

src_install () {
	default

	rm -f ChangeLog README LICENSE

	insinto /usr/share/${PN}
	doins -r *
}

pkg_postinst () {
	elog "Please follow the instructions in /usr/share/doc/${P}/README."
}
