# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="sh.eselect-${PV}"
DESCRIPTION="Manages the /bin/sh (POSIX shell) symlink"
HOMEPAGE="http://github.com/mgorny/eselect-sh/"
SRC_URI="http://github.com/downloads/mgorny/${PN}/${MY_P}.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="app-admin/eselect"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${MY_P}" sh.eselect || die "newins failed"
}
