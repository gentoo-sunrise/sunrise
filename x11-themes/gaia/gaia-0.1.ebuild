# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

ARTS_REQUIRED="never"
inherit kde

MY_P="GAIA_KWin-${PV}"

DESCRIPTION="Gaia KDE Native Window Decoration style"
HOMEPAGE="http://works13.com/works/gaia-for-kdekwin3x.htm"
SRC_URI="http://works13.com/downloads/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

DEPEND="|| ( kde-base/kwin:3.5 kde-base/kdebase:3.5 )"
RDEPEND="${DEPEND}"

set-kdedir 3.5
