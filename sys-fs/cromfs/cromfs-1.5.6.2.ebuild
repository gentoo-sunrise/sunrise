# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Cromfs is a FUSE based compressed read-only filesystem for Linux."
HOMEPAGE="http://bisqwit.iki.fi/source/cromfs.html"
SRC_URI="http://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="static"

DEPEND=">=sys-fs/fuse-2.5.2"
RDEPEND="${DEPEND}"

src_compile() {
	sed -i -e '/upx/d' -e '/- strip/d' Makefile || die "sed failed to remove UPX
	and strip."
	econf
	emake || die "Make failed."
}

src_install() {
	if use static; then
		dobin cromfs-driver-static || die "Couldn't find the static binary to
		install."
	fi
	dobin cromfs-driver util/mkcromfs util/unmkcromfs util/cvcromfs || die "Some
	binaries failed to install."
	dodoc doc/*.txt doc/FORMAT doc/ChangeLog || die
	dohtml doc/*.html doc/*.png || die
}
