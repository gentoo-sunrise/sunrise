# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

ARTS_REQUIRED="never"
inherit kde rpm

DESCRIPTION="Pureline KDE Native Window Decoration style"
HOMEPAGE="http://kde-look.org/content/show.php?content=30501"
#Offcial Lycos Homepage is offline
#SRC_URI="http://mitglied.lycos.de/cswb/deco/pureline-0.1.tar.gz"
SRC_URI="ftp.gwdg.de/pub/linux/misc/suser-guru/rpm/packages/Themes-KDE3/${PN}/src/${P}-1.guru.suse93.kde34.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="|| ( kde-base/kwin:3.5 kde-base/kdebase:3.5 )"
RDEPEND="${DEPEND}"

set-kdedir 3.5
