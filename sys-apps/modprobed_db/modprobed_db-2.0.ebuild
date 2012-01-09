# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Keeps track of EVERY kernel module that has ever been probed. Useful for 'make localmodconfig'"
HOMEPAGE="https://wiki.archlinux.org/index.php/Modprobed_db"
SRC_URI="http://repo-ck.com/source/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/xz-utils"
RDEPEND="sys-apps/module-init-tools"

src_install() {
	dobin ${PN}
	insinto /etc
	doins ${PN}.conf
	newdoc README* README
	newman ${PN}.manpage ${PN}.1
}
