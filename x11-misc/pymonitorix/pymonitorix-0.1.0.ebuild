# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Panel applet for a local or remote monitorix installation"
HOMEPAGE="http://www.monitorix.org/"
SRC_URI="http://www.monitorix.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/pygtk"

src_install() {
	distutils_src_install

	insinto "$(python_get_sitedir)/${PN}"
	doins "${FILESDIR}/config.py" || die "doins failed"
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "If you want to monitor your local box you also need to emerge "
	elog "www-misc/monitorix"
}
