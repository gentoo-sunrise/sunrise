# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
NEED_KDE="4.1"

inherit kde4-base

MY_P=${PN/-/}
F_P="${P}-kde4"

DESCRIPTION="Antispam filter for Kopete instant messenger."
HOMEPAGE="http://kopeteantispam.sourceforge.net"
SRC_URI="mirror://sourceforge/${MY_P}/${F_P}.tar.gz"

LICENSE="GPL-2"
SLOT="4.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="kde-base/kopete:4.1"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${F_P}"


pkg_postinst() {
	elog "You can now enable and set up the Antispam plugin in Kopete."
	elog "It can be reached in the Kopete Plugin dialog."
}
