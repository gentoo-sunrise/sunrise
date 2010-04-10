# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Plugin for Pidgin that reminds you of your buddies birthdays"
HOMEPAGE="https://sourceforge.net/projects/pidgin-birthday"
SRC_URI="mirror://sourceforge/${PN/-reminder/}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/pidgin[gtk]"
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die "install fail"
	dodoc AUTHORS ChangeLog || die "doc install fail"
}
