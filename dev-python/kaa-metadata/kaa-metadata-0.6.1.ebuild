# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python eutils distutils

DESCRIPTION="A powerful media metadata parser. The module is the successor of MMPython."
HOMEPAGE="http://freevo.sourceforge.net/kaa/"
SRC_URI="mirror://sourceforge/freevo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dvd css"

RDEPEND=">=dev-python/kaa-base-0.1.3
	dvd? ( media-libs/libdvdread )
	css? ( media-libs/libdvdcss )"

