# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A monitoring system based on Nagios"
HOMEPAGE="http://sourceforge.net/projects/icinga/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_compile() {
	econf --with-posix-regex
	emake 'all' || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install 'all' || die "install failed"

	dodoc README THANKS AUTHORS || die "dodoc failed"
}