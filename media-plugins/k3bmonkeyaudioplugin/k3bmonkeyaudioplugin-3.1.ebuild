# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit eutils

DESCRIPTION="K3b Monkey's Audio Encoder and Decoder plugin"
HOMEPAGE="http://www.k3b.org"
SRC_URI="mirror://sourceforge/k3b/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="arts"

DEPEND="app-cdr/k3b
	arts? ( kde-base/arts )"
RDEPEND="${DEPEND}"

pkg_setup() {
	local fail="Re-emerge app-cdr/k3b with USE arts."

	if use arts && ! built_with_use app-cdr/k3b arts; then
		eerror "${fail}"
		die "${fail}"
	fi
}

src_compile() {
	econf $(use_with arts) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"	
	dodoc AUTHORS ChangeLog README TODO
}
