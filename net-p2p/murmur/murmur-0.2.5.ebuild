# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="PyGTK client for museek+"
HOMEPAGE="http://museek-plus.org/wiki/murmur"
SRC_URI="mirror://sourceforge/museek-plus/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="trayicon"

DEPEND=">=dev-lang/python-2.4.3"
RDEPEND="${DEPEND}
	>=dev-python/pygtk-2.6.1
	>=net-p2p/museek+-0.1.12"

src_compile() {
	distutils_src_compile
	if use trayicon ; then
		cd "${S}/trayicon"
		./autogen.py || die "./autogen.py trayicon failed"
		emake || die "emake trayicon failed"
		cd "${S}"
	fi
}

src_install() {
	distutils_src_install
	if use trayicon ; then
		cd "${S}/trayicon"
		emake DESTDIR="${D}" install || die "emake trayicon failed"
	fi
}
