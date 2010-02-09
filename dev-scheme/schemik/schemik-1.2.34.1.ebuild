# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit toolchain-funcs

DESCRIPTION="High-level lexically-scoped implicitly-parallel dialect of Scheme and Common LISP"
HOMEPAGE="http://schemik.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-libs/boehm-gc
	sys-libs/readline"

DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

src_prepare() {
	sed -i \
	-e 's/\(COMP_ARGS=\)-g \(-Wall -Winline\) -O2/\1$(CFLAGS) \2/' \
	-e 's/gcc/$(CC)/' Makefile || die "patching Makefile failed"
}

src_compile() {
	emake CC=$(tc-getCC)|| die "emake failed"
}

src_install() {
	dobin schemik || die "dobin failed"
	dodoc README || die "dodoc failed"
}
