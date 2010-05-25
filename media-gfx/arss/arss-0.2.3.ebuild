# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils

MY_P=${P}-src

DESCRIPTION="Analysis & Resynthesis Sound Spectrograph"
HOMEPAGE="http://arss.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"
IUSE=""

DEPEND="sci-libs/fftw"
RDEPEND="${DEPEND}"

CMAKE_IN_SOURCE_BUILD="TRUE"
S=${WORKDIR}/${MY_P}/src

DOCS="../AUTHORS ../ChangeLog"
