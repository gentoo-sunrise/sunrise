# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils flag-o-matic

MY_P="${P}_autoconf"

DESCRIPTION="Stressful Application Test"
HOMEPAGE="http://code.google.com/p/stressapptest/"
SRC_URI="http://stressapptest.googlecode.com/files/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
IUSE="debug"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-flags.patch \
		"${FILESDIR}"/${PV}-nolicense.patch
	eautoreconf
	use debug || append-flags -DNDEBUG
}

src_install() {
	emake DESTDIR="${D}" install || die
}
