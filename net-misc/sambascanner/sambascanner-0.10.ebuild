# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="a tool to search a whole samba network for files"
HOMEPAGE="http://www.johannes-bauer.com/sambascanner/"
SRC_URI="http://www.johannes-bauer.com/${PN}/SambaScanner-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-fs/samba-3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/SambaScanner-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	dobin sambascanner sambaretrieve smblister
	dodoc ChangeLog
}
