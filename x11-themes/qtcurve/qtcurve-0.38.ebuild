# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils kde

MY_P="${P/qtcurve/QtCurve}"

DESCRIPTION="A set of widget styles for KDE, GTK1, and GTK2 based apps."
HOMEPAGE="http://www.kde-look.org/content/show.php?content=40492"
SRC_URI="http://home.freeuk.com/cpdrummond/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README TODO
}
