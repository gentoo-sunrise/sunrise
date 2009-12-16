# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools multilib

MY_P="leptonlib-${PV}"
DESCRIPTION="An open source C library for image processing and analysis"
HOMEPAGE="http://code.google.com/p/leptonica/"
SRC_URI="http://leptonica.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/jpeg
	media-libs/giflib
	media-libs/tiff"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# build shared library
	epatch "${FILESDIR}"/${PN}-build-shared.diff

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die 'emake install failed.'
	dohtml {README,version-notes}.html || die 'dohtml failed.'

	# remove .la file, it was needed only to build shared lib
	rm "${D}"/usr/$(get_libdir)/liblept.la || die 'rm failed.'
}
