# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

DESCRIPTION="Apache C++ XML security libraries."
HOMEPAGE="http://santuario.apache.org/"
SRC_URI="http://santuario.apache.org/dist/c-library/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug examples xalan ssl"

RDEPEND=">=dev-libs/xerces-c-3
	xalan? ( dev-libs/xalan-c )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}/${PV}-parallel_build.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_with xalan) \
		$(use_with ssl openssl)
}

src_install(){
	emake DESTDIR="${D}" install || die "emake failed"

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins src/samples/*.cpp
	fi
}
