# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib toolchain-funcs

DESCRIPTION="OpenGL video capturing library"
HOMEPAGE="http://neopsis.com/projects/seom"
SRC_URI="http://dbservice.com/ftpdir/tom/seom/trunk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=">=dev-lang/yasm-0.6.0"

src_compile() {
	unset ARCH
	econf --cflags="${CFLAGS}"
	emake CC="$(tc-getCC)" || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install || die "emake install failed."
}
