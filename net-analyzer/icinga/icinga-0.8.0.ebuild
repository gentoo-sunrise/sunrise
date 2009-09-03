# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A monitoring system based on Nagios"
HOMEPAGE="http://sourceforge.net/projects/icinga/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_compile() {
	econf --with-posix-regex
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc README THANKS AUTHORS || die "dodoc failed"
}
