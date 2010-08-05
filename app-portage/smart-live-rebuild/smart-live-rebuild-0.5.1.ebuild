# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND=*
inherit python

DESCRIPTION="Update live packages and emerge the modified ones"
HOMEPAGE="http://qwpx.net/~mgorny/smart-live-rebuild/"
SRC_URI="http://qwpx.net/~mgorny/${PN}/${P}.tar.bz2"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	newbin ${PN}.py ${PN} || die
	dodoc README sets.conf.example || die
	insinto /etc/portage
	newins smart-live-rebuild.conf{.example,} || die
	insinto /usr/share/portage/config/sets
	newins sets.conf.example ${PN}.conf || die
}

pkg_postinst() {
	elog "You might also consider installing [dev-python/psutil] then, which is required"
	elog "for ${PN} automatically detect if it was spawned by emerge."
}
