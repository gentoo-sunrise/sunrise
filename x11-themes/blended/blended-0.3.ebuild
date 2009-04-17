# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit kde
ARTS_REQUIRED="never"


MY_P="Blended-${PV}"
DESCRIPTION="Blended KDE Native Window Decoration style"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=32613"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/32613-${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

DEPEND="|| ( kde-base/kwin:3.5 kde-base/kdebase:3.5 )"
RDEPEND="${DEPEND}"

set-kdedir 3.5
