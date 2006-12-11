# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/_/-}
DESCRIPTION="A minimalist FIFO and filesystem-based IRC client"
HOMEPAGE="http://irc.suckless.org/"
SRC_URI="http://suckless.org/download/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake || die "Compilation failed"
}

src_install() {
	dobin ii
	dodoc README FAQ LICENSE
	doman *.1
}
