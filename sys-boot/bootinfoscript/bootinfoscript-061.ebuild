# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Displays boot information in a convenient format to troubleshoot booting problems"
HOMEPAGE="http://bootinfoscript.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-shells/bash"
DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_install() {
	dobin bootinfoscript
	dodoc README CHANGELOG
}
