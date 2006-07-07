# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils multilib toolchain-funcs

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="http://www.nicotine-plus.org"

SRC_URI="http://thegraveyard.org/daelstorm/nicotine/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc"
IUSE="vorbis geoip"

RDEPEND="virtual/python
	>=dev-python/pygtk-2
	vorbis? ( >=dev-python/pyvorbis-1.4-r1
			  >=dev-python/pyogg-1 )
	geoip? ( >=dev-python/geoip-python-0.2.0
			 >=dev-libs/geoip-1.2.1 )
	!net-p2p/nicotine"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {

	distutils_src_compile

	cd "${S}"/trayicon/
	./autogen.py
	sed -i -e "s:/lib/:/$(get_libdir)/:" \
		Makefile || die "sed failed"
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {

	distutils_python_version
	distutils_src_install --install-lib \
		/usr/$(get_libdir)/python${PYVER}/site-packages

	cd "${S}"/trayicon/
	emake DESTDIR="${D}" install || die "emake install failed"

	doicon ${FILESDIR}/nicotine-n.png
	domenu ${FILESDIR}/${PN}.desktop
}
