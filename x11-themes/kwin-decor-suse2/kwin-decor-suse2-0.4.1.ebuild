# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

need-kde 3.5

DESCRIPTION="KDE window decoration as used in SuSE 9.3/10.0/10.1 - improved"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=23579"
SRC_URI="http://www.gerdfleischer.de/kwin-decor-suse2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/kwin-decor-suse2-disabletitlebarlogo.patch" )
