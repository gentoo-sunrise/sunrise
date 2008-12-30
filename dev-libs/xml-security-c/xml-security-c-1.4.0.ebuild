# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Apache C++ XML security libraries."
HOMEPAGE="http://santuario.apache.org/"
SRC_URI="http://xml.apache.org/security/dist/c-library/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xalan"

RDEPEND="=dev-libs/xerces-c-2*
	xalan? ( =dev-libs/xalan-c-1.10* )
	dev-libs/openssl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile () {
	econf $(use_with xalan)
	emake || die "emake failed"
}

src_install(){
	emake DESTDIR="${D}" install || die "emake failed"
}
