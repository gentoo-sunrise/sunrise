# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mercurial

DESCRIPTION="A minimalist FIFO and filesystem-based IRC client."
HOMEPAGE="http://irc.suckless.org/"
SRC_URI=""
EHG_REPO_URI="http://suckless.org/cgi-bin/hgwebdir.cgi/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_install() {
	dobin ii
	dodoc FAQ README
	doman ii.1
}
