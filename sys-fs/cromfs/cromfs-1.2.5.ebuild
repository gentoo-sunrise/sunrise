# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="a FUSE-based compressed read-only filesystem"
HOMEPAGE="http://bisqwit.iki.fi/source/cromfs.html"
SRC_URI="http://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="static"

DEPEND=">=sys-fs/fuse-2.5.2"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e '/upx/d' -e '/strip/d' Makefile \
		|| die "sed failed in Makefile"
	for i in Makefile util/Makefile ; do
		sed -i -e "/^CXXFLAGS +=/s:-O3::" \
			-e "/OPTIM +=/s:-O3::" ${i} \
		|| die "sed failed in ${i}"
	done
	for i in Makefile.sets util/Makefile.sets ; do
		sed -i -e "/^CC=/s:gcc:$(tc-getCC):" \
			-e "/^CPP=/s:g++:$(tc-getCPP):" \
			-e "/^CXX=/s:g++:$(tc-getCXX):" \
			-e "/^CPPFLAGS=/s:-pipe -g::" \
			-e "/^OPTIM/s:=.*:=${CXXFLAGS}:" \
			-e "/^LDFLAGS/s:=.*:+=:" ${i} \
		|| die "sed failed in ${i}"
	done
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	use static && dobin cromfs-driver-static
	dobin cromfs-driver util/{mkcromfs,unmkcromfs,cvcromfs}

	dodoc doc/*.txt doc/{FORMAT,ChangeLog}
	dohtml doc/*.{html,png}
}
