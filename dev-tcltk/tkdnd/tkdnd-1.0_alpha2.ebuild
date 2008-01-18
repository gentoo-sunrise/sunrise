# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=${P/_alpha/a}

DESCRIPTION="TkDnD is an extension that adds native drag & drop capabilities to the tk toolkit."
HOMEPAGE="http://www.iit.demokritos.gr/~petasis/Tcl/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="test"

DEPEND=">=dev-lang/tcl-8.4
	>=dev-lang/tk-8.4"

S=${WORKDIR}/${MY_P}/unix/

src_unpack() {
	unpack ${A}
	# Patch to avoid a sandbox issue
	epatch "${FILESDIR}/${P}-destdir-issue.diff"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc doc/* Readme.txt
}
