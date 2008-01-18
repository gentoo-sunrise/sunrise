# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="This is a growing collection of the unix tools that nobody thought to write thirty years ago"
HOMEPAGE="http://www.kitenet.net/~joey/code/moreutils.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/m/moreutils/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="doc? ( =app-text/docbook-xml-dtd-4.4*
		app-text/docbook2X )"
RDEPEND="dev-lang/perl"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	sed -i \
		-e 's/^CFLAGS/#CFLAGS/' \
		-e 's/-s//' \
		-e 's/docbook2x-man $</docbook2man.pl $< >$@/g' \
		"${S}/Makefile" || die "sed failed"

	if use doc; then
		sed -i \
			-e 's#file.*/xml/\(.*docbookx.dtd\)#\1#g' \
			$(find "${S}" -iname *.docbook -printf '%p ') || die "sed failed"

	else
		sed -i \
			-e 's/^MANS/#/' \
			-e 's#install $(MANS) $(PREFIX)/usr/share/man/man1##' \
			-e 's#mkdir -p $(PREFIX)/usr/share/man/man1##' \
			"${S}/Makefile" || die "sed failed"

	fi
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake PREFIX="${D}" install || die "emake install failed"
	dodoc README
}
