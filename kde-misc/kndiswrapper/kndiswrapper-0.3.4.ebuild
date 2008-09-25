# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit kde

DESCRIPTION="A QT frontend for ndiswrapper"
HOMEPAGE="http://www.kde-apps.org/content/show.php/KNDISWrapper?content=86885"
SRC_URI="http://www.linux-specialist.com/download/source/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

need-kde 3.5

RDEPEND="net-misc/dhcpcd
	sys-apps/net-tools
	net-wireless/ndiswrapper
	net-wireless/wireless-tools
	net-wireless/wpa_supplicant"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README || die "dodoc failed"
}
