# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base toolchain-funcs

DESCRIPTION="Text editor with extensive Unicode and CJK support"
HOMEPAGE="http://mined.sourceforge.net/"
SRC_URI="http://towo.net/mined/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DOCS=( README CHANGES )

src_prepare() {
	default

	# Disable stripping and supply the correct compiler
	# we can't just pass CC as upstream uses it as a keyword-var
	sed -i -e '/strip/d' -e "s/\$(CC)/$(tc-getCC)/" src/mkinclud.mak || die
}

src_compile() {
	emake OPT="${CFLAGS}" || die
}
