# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python

DESCRIPTION="A PyGTK program for editing fstab"
HOMEPAGE="http://pysdm.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk
	>=dev-lang/python-2.4"

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc NEWS TODO
	cd "${PN}"
	newbin pysdm.py pysdm || die "failed to create executable"
}

pkg_postinst() {
	python_mod_optimize /usr/share/pysdm/fsdata/
}

pkg_postrm() {
	python_mod_cleanup /usr/share/pysdm/fsdata/
	python_mod_cleanup
}
