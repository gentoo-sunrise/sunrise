# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

MY_P="SambaScanner-${PV}"
DESCRIPTION="a tool to search a whole samba network for files"
HOMEPAGE="http://www.johannes-bauer.com/sambascanner/"
SRC_URI="http://www.johannes-bauer.com/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-fs/samba-3"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	if ! built_with_use --missing true sys-libs/glibc nptl; then
		die "Sambascanner requires an NPTL system"
	fi
	unpack ${A}
	cd "${S}"
}

src_compile() {
	econf CFLAGS="${CFLAGS} -pthread" || die "configure failed"
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	dobin src/sambascanner bin/sambaretrieve src/smblister
	dodoc ChangeLog
}
