# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Automatic open port forwarder using UPnP"
HOMEPAGE="http://proj.mgorny.alt.pl/misc/#autoupnp"
SRC_URI="http://dl.mgorny.alt.pl/misc/${P}.sh.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="net-misc/miniupnpc
	sys-apps/diffutils
	sys-apps/net-tools"

src_install() {
	newbin ${P}.sh ${PN} || die
}
