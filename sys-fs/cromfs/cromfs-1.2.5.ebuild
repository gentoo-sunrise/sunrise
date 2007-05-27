# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Cromfs is a FUSE based compressed read-only filesystem for Linux."
HOMEPAGE="http://bisqwit.iki.fi/source/cromfs.html"
SRC_URI="http://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~x86"
IUSE="static"

DEPEND=">=sys-fs/fuse-2.5.2"
RDEPEND="${DEPEND}"

src_compile() {
	sed -r -i -e '/- (upx|strip)/d' Makefile
	emake -j1
}

src_install() {
	exeinto /usr/bin
	if use static; then
		doexe cromfs-driver-static
	fi
	doexe cromfs-driver util/mkcromfs util/unmkcromfs util/cvcromfs
	dodoc doc/*.txt doc/FORMAT doc/ChangeLog COPYING
	insinto /usr/share/doc/${PF}
	doins doc/*.html doc/*.png
}
