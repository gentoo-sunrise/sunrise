# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="general purpose shared library for programs gathering ACPI data on Linux"
HOMEPAGE="http://ngolde.de/libacpi.html"
SRC_URI="http://ngolde.de/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-config.patch
	epatch "${FILESDIR}"/${PV}-Makefile.patch
}

src_compile() {
	emake \
		CC=$(tc-getCC) || \
		die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || \
		die "install failed"
	dodoc AUTHORS CHANGES README || die "nothing to read"
	if use doc; then
		dohtml doc/html/* || die " no docs"
	fi
}
