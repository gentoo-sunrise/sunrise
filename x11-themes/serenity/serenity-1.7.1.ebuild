# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit kde

DESCRIPTION="KDE style and native window decoration"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=35954"
SRC_URI="http://maxilys.ifastnet.com/archives/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="|| ( kde-base/kwin:3.5 kde-base/kdebase:3.5 )
	!x11-themes/serenity-decoration
	!x11-themes/serenity-style"

need-kde 3.4
