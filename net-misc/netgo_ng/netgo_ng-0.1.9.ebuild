# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="A Qt based gui for wire-bound and wireless network setup"
HOMEPAGE="http://www.kde-apps.org/content/show.php/netgo_ng?content=88232"
SRC_URI="http://www.linux-specialist.com/download/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

need-kde 3.5

RDEPEND="net-misc/dhcpcd
	sys-apps/net-tools
	net-wireless/wireless-tools
	net-wireless/wpa_supplicant"

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc authors ChangeLog readme todo
}
