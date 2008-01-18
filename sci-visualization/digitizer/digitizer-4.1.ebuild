# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator qt3
MY_PV=$(replace_version_separator 1 '_')

DESCRIPTION="Engauge Digitizer converts an image file showing a graph or map, into numbers"
HOMEPAGE="http://digitizer.sourceforge.net/"
SRC_URI="mirror://sourceforge/digitizer/digit-src-${MY_PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
SLOT="0"

DEPEND="=x11-libs/qt-3*
	>=sci-libs/fftw-3.1.2"

S="${WORKDIR}/engauge"

src_compile() {
	eqmake3 digitizer.pro
	emake || die "make failed"
}

src_install() {
	dobin bin/engauge
	dodoc README RELEASE
	dohtml usermanual/*

	if use examples ; then
		insinto /usr/share/${PN}/samples
		doins samples/*
	fi
}
