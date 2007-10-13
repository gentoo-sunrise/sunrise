# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A Query Object Framework"
HOMEPAGE="http://qof.sourceforge.net/"
SRC_URI="mirror://sourceforge/qof/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
