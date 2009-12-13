# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Pidgin plugin that reverses any word on all conversation"
HOMEPAGE="http://sourceforge.net/projects/convreverse/"
SRC_URI="mirror://sourceforge/${PN/pidgin-/}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/pidgin[gtk]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_install() {
	emake install DESTDIR="${D}" || die "install fail"
	dodoc AUTHORS ChangeLog || die "doc install fail"
}


