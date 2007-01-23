# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

MY_P=${P/-/.}

DESCRIPTION="Serenity is a KDE style with a matching window decoration"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=35954"
SRC_URI="http://maxilys.awardspace.com/archives/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

DEPEND="|| ( kde-base/kwin kde-base/kdebase )"
RDEPEND="${DEPEND}"

need-kde 3.5

S=${WORKDIR}/${MY_P}
