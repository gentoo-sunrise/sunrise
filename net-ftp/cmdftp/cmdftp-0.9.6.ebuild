# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Light weight, yet robust command line FTP client with shell-like
functions."
HOMEPAGE="http://savannah.nongnu.org/projects/cmdftp/"
SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="onlysmall"

DEPEND=""
RDEPEND=""

src_compile() {
	econf $(use_enable !onlysmall largefile) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README AUTHORS
}
