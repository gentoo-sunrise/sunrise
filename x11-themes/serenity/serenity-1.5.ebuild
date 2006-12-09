# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="KDE style and native window decoration"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=35954"
SRC_URI="http://maxilys.awardspace.com/archives/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"
IUSE=""

DEPEND="|| ( kde-base/kwin kde-base/kdebase )
	!x11-themes/serenity-decoration
	!x11-themes/serenity-style"

need-kde 3.4
