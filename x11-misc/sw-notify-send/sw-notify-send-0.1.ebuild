# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="A system-wide notification wrapper for notify-send"
HOMEPAGE="http://proj.mgorny.alt.pl/misc/#sw-notify-send"
SRC_URI="http://dl.mgorny.alt.pl/misc/${P}.c.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-process/procps"
RDEPEND="${DEPEND}
	x11-libs/libnotify"

src_compile() {
	"$(tc-getCC)" ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} ${P}.c -o ${PN} -lproc || die
}

src_install() {
	dobin ${PN} || die
}
