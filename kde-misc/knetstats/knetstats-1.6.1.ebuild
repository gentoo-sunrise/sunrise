# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="A simple KDE network monitor that show rx/tx LEDs or numeric information about the transfer rate of any network interface in a system tray."
HOMEPAGE="http://knetstats.sourceforge.net/"
SRC_URI="mirror://sourceforge/knetstats/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

need-kde 3
