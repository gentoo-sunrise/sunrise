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
RDEPEND="${DEPEND}"

# The lack of x11-libs/libnotify RDEPEND is intentional. The tool supports
# calling 'notify-send' from within a chroot running libnotify-enabled system
# where the host system is libnotify-free. Not to mention that running
# a libnotify notification daemon implies having libnotify installed.

src_compile() {
	"$(tc-getCC)" ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} ${P}.c -o ${PN} -lproc || die
}

src_install() {
	dobin ${PN} || die
}
