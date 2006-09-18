# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

MY_P="${P/_beta1/Beta1}"

DESCRIPTION="Widget style + kwin decoration both aimed to be a good balance between eye candy and simplicity."
HOMEPAGE="http://www.kde-look.org/content/show.php?content=27968"
SRC_URI="http://www.notmart.org/files/${MY_P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="kdeenablefinal"
RESTRICT="confcache"

DEPEND="|| ( kde-base/kwin kde-base/kdebase )"
RDEPEND="${DEPEND}"

need-kde 3.4

S="${WORKDIR}/${MY_P}"

src_compile() {
	myconf="${myconf} $(use_enable kdeenablefinal final)"
	kde_src_compile
}
