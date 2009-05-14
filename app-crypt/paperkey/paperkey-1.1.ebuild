# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="OpenPGP key archiver"
HOMEPAGE="http://www.jabberwocky.com/software/paperkey/"
SRC_URI="http://www.jabberwocky.com/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "unable to install"
	dodoc README || die "unable to install documentation"
}
