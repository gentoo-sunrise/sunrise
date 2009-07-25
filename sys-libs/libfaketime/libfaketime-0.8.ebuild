# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="FakeTime Preload Library"
HOMEPAGE="http://www.code-wizards.com/projects/libfaketime/"
SRC_URI="http://www.code-wizards.com/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

#FIXME: Write a fix for make test (only libfaketime.so seems to be tested)

src_compile() {
	sed -i 's:${CC}:$(CC) $(CFLAGS) $(LDFLAGS):;
		s:\(soname,libfaketime\.so\)\.1:\1:' Makefile || die "sed failed"
	emake libs || die "make libs failed"
}

src_install() {
	local my_bin=${PN/lib}

	dosym ${PN}.so.1 /usr/$(get_libdir)/${PN}.so \
		|| die "dosym ${PN}.so failed"
	dosym ${PN}MT.so.1 /usr/$(get_libdir)/${PN}MT.so \
		|| die "dosym ${PN}MT.so failed"
	dolib ${PN}*.so* || die "dolib failed"
	dobin ${my_bin}   || die "dobin failed"
	doman ${my_bin}.1 || die "doman failed"
	dodoc README Changelog || die "dodoc failed"
}
