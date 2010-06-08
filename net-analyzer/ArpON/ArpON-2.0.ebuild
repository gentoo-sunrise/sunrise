# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit cmake-utils

DESCRIPTION="ArpON (Arp handler inspectiON) is a portable Arp handler."

HOMEPAGE="http://arpon.sourceforge.net/"
SRC_URI="mirror://sourceforge/arpon/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND="dev-libs/libdnet
	net-libs/libnet:1.1
	net-libs/libpcap"

RDEPEND=${DEPEND}
