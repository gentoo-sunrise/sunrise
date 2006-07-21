# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit bash-completion

DESCRIPTION="A Portage analysis toolkit"
HOMEPAGE="http://catmur.co.uk/gentoo/udept"
SRC_URI="http://gentooexperimental.org/~genstef/dist/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="app-shells/bash"
RDEPEND=${DEPEND}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin dep || die "dobin failed"
	doman dep.1
	dodoc ChangeLog*
	dobashcompletion dep.completion dep
}

pkg_posinst() {
	bash-completion_pkg_postinst
}
