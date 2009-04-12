# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde eutils

MY_P=${P/_/-}

DESCRIPTION="a tool which can be used for developing microcontroller software"
HOMEPAGE="http://www.cadmaniac.org/projectMain.php?projectName=kontrollerlab"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${MY_P}

need-kde 3.5
