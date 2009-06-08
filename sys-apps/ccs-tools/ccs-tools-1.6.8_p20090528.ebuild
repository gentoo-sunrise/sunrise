# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/_p/-}"
DESCRIPTION="TOMOYO Linux tools"
HOMEPAGE="http://www.sourcefoge.jp/projects/tomoyo/"
SRC_URI="mirror://sourceforge.jp/tomoyo/30298/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="virtual/libc
	sys-libs/ncurses
	sys-libs/readline"
RDEPEND="${DEPEND}"

S="${WORKDIR}/ccstools/"

src_install() {
	emake INSTALLDIR="${D}" install || die

	rm "${D}"/usr/lib/ccs/ccstools.conf || die
	insinto /usr/lib/ccs/conf
	doins ccstools.conf || die
	dosym /usr/lib/ccs/conf/ccstools.conf /usr/lib/ccs/ccstools.conf || die
	doenvd "${FILESDIR}/50ccs-tools" || die
}
