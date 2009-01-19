# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Utility that reports when files have been altered"
HOMEPAGE="http://fileschanged.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls"

DEPEND="virtual/fam"
RDEPEND="${DEPEND}"

src_compile() {
	econf $(use_enable nls)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README TODO || die "dodoc failed"
	# make install installs the doc files in wrong directory.
	rm -rf "${D}"/usr/share/${PN}
}
