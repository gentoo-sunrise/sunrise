# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.5"

inherit python distutils

DESCRIPTION="Fork of Comix, a GTK image viewer specifically designed to handle comic books"
HOMEPAGE="http://mcomix.sourceforge.net"
SRC_URI="mirror://sourceforge/mcomix/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/pygtk-2.14
	>=dev-python/imaging-1.1.5
	dev-python/setuptools"
RDEPEND="${DEPEND}"

pkg_postinst() {
	elog "To extract archives on-the-fly, the corresponding applications from app-arch are required."
	elog "app-arch/unrar for rar archives, app-arch/p7zip for 7z archives, and app-arch/lha"
	elog "for lha archives are supported."
}
