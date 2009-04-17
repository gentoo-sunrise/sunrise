# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit versionator qt3
MY_PV=$(replace_version_separator 1 '_')

DESCRIPTION="Engauge Digitizer converts an image file showing a graph or map, into numbers"
HOMEPAGE="http://digitizer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/digit-src-${MY_PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
SLOT="0"

DEPEND="x11-libs/qt:3
	>=sci-libs/fftw-3.1.2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/engauge"

src_compile() {
	eqmake3 digitizer.pro
	emake || die "make failed"
}

src_install() {
	dobin bin/engauge || die "dobin failed"
	dodoc README RELEASE || die "dodoc failed"
	dohtml usermanual/* || die "dohtml failed"

	if use examples ; then
		docinto examples
		dodoc samples/* || die "dodoc examples failed"
	fi
}
