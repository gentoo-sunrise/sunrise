# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="A KDE Portage browser"
HOMEPAGE="http://kuroo.org"
SRC_URI="http://files.kuroo.org/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

pkg_postinst() {
	elog "Kuroolito requires the portage sqlite module to work. See http://gentoo-wiki.com/TIP_speed_up_portage_with_sqlite"
	elog "You must uncomment line 'portdbapi.auxdbmodule = cache.sqlite.database' in /etc/portage/modules"
	elog "Remember to run 'emerge --regen' to update Portage cache after each sync"
}

need-kde 3.5
