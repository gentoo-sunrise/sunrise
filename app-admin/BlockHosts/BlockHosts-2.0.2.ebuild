# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Blocks abusive IP hosts which probe your services (such as sshd, proftpd)"
HOMEPAGE="http://www.aczoom.com/cms/blockhosts/"
SRC_URI="http://www.aczoom.com/tools/blockhosts/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_install() {
	dobin bhrss.py blockhosts.py || die "installation failed"
	dodoc CHANGES INSTALL README
	dohtml *.html
	
	insinto /etc
	doins blockhosts.cfg
}

pkg_postinst() {
	echo
	elog "This package isn't configured properly."
	elog "Please refer to the homepage to do this!"
	echo
}
