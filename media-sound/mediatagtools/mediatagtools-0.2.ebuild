# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Media Tag Tools - a mp3/ogg/flac tagger"
HOMEPAGE="http://mediatagtools.berlios.de"
SRC_URI="mirror:/berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="=x11-libs/qt-3*
		>=media-libs/taglib-1.4"
RDEPEND="${DEPEND}"

src_compile() {
	cd "${S}"
	# Without this qmake find the wrong version of uic
	PATH="${QTDIR}/bin:${PATH}"
	# Asked around, the only way to ensure non-interactivity
	echo "${D}/usr/" | qmake || die "failed to configure"
	emake || die "failed to make"
}

src_install() {
	emake install INSTALL_ROOT="${D}/usr/" || die "make install failed"
}
