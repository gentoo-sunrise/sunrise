# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MY_PN=ReviewBoard
MY_P=${MY_PN}-${PV}

inherit distutils python versionator

DESCRIPTION="A web-based tool designed to track of pending code changes and make code reviews much less painful"
HOMEPAGE="http://www.reviewboard.org/"
SRC_URI="http://downloads.${PN}.org/releases/${MY_PN}/$(get_version_component_range 1-2)/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/django
	dev-python/flup
	dev-python/imaging
	dev-python/paramiko
	dev-python/pygments
	dev-python/python-memcached
	|| ( ( www-servers/apache
		|| ( www-apache/mod_fastcgi www-apache/mod_python ) )
		www-servers/lighttpd )"

S=${WORKDIR}/${MY_P}

pkg_postinst() {
	distutils_pkg_postinst
	elog "For support of a certain VCS, please install"
	elog "dev-util/cvs, dev-vcs/git, dev-vcs/mercurial or dev-util/subversion."
	elog "Please emerge django with mysql, postgres or sqlite USE flag"
	elog "for the corresponding database backends."
}
