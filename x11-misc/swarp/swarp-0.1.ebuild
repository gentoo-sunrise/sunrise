# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Simple mouse pointer warp"
HOMEPAGE="http://tools.suckless.org/swarp"
SRC_URI="http://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "/strip/d" \
		Makefile || die "sed failed"

	sed -i \
		-e "s/^CFLAGS = -Os/CFLAGS +=/" \
		-e "s/^LDFLAGS =/LDFLAGS +=/" \
		-e "/^CC/d" \
		config.mk || die "sed failed"
}

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install || die "emake install failed"

	dodoc README || die "dodoc failed"
}
