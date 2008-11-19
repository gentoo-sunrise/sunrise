# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Restricted user shell intended for use with ssh, rsh and similar."
HOMEPAGE="http://puszcza.gnu.org.ua/projects/rush"
SRC_URI="ftp://download.gnu.org.ua/pub/release/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_install() {
	dodoc THANKS AUTHORS README NEWS || die "copying documentation failed"
	emake DESTDIR="${D}" install || die "emake install failed"
}
