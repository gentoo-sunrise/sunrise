# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A simple utility that allows you to easily rename multiple files."
HOMEPAGE="http://home.hccnet.nl/paul.schuurmans/linux/"
SRC_URI="http://home.hccnet.nl/paul.schuurmans/linux/download/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.3"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Replace the CFLAGS with our own custom CFLAGS
	sed -i -e "s:^CFLAGS =:CFLAGS ?=:" Makefile || die "sed Makefile failed"
}

src_install() {
	dodoc AUTHORS ChangeLog README TODO || die "dodoc failed"
	dobin cfnrename || die "dobin failed"
}
