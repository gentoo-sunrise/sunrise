# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="kde remote desktop connections manager"
HOMEPAGE="http://krdm.sourceforge.net/"
SRC_URI="mirror://sourceforge/krdm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vnc rdesktop"

RDEPEND="|| (
			vnc? ( >=net-misc/tightvnc-1.2.9-r3 )
			rdesktop? ( >=net-misc/rdesktop-1.4.1 )
		)"
DEPEND=""

S="${WORKDIR}/${PN}"

need-kde 3.4
