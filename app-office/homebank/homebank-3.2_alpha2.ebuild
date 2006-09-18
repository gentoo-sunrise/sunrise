# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="HomeBank is the free software you have always wanted to manage your personal accounts at home"
HOMEPAGE="http://homebank.free.fr/index.php"
SRC_URI="http://homebank.free.fr/public/${P/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="x11-libs/gtk+"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
