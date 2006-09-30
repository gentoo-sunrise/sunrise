# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

KEYWORDS="~x86"

DESCRIPTION="A firewall log monitor for KDE."
HOMEPAGE="http://klogwatch.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

need-kde 3.5

DEPEND=""
RDEPEND=""
