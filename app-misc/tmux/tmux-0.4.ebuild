# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Simple, modern, alternative to programs such as GNU screen"
HOMEPAGE="http://tmux.sourceforge.net"
SRC_URI="mirror://sourceforge/tmux/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="debug examples"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	if use debug ; then
		sed -i "/DEBUG/s/^#//" GNUmakefile || die "sed debug failed"
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		MANDIR="/usr/share/man/man1" \
		PREFIX="/usr" install || die "emake install failed"

	dodoc NOTES TODO

	if use examples ; then
		docinto examples
		dodoc examples/*
	fi
}

pkg_postinst() {
	elog "NOTE that tmux doesn't support \\\033_string\\\033\\\\\\ for window"
	elog "titles. If you're using BASH unset PROMPT_COMMAND."
}
