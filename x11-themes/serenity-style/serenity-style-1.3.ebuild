# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="Serenity is a KDE style with a matching window decoration"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=35954"
SRC_URI="http://maxilys.awardspace.com/archives/${P/-/.}.tar.bz2"
S=${WORKDIR}/${P/-/.}

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"
IUSE=""
RESTRICT="nomirror"

DEPEND="|| ( kde-base/kwin kde-base/kdebase )"

need-kde 3.2

