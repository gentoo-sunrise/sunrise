# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit cmake-utils eutils flag-o-matic versionator

MY_P=${PN}-$(replace_version_separator _ .)
DESCRIPTION="X11 desktop video grabber tray"
HOMEPAGE="http://qx11grab.hjcms.de/"
SRC_URI="http://qx11grab.hjcms.de/Downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/qt-gui:4[dbus]
	media-video/ffmpeg[X]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	# Required by ffmpeg headers.
	append-flags -D__STDC_CONSTANT_MACROS
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-as-needed.patch

	# Move docs to DOCDIR.
	sed -i \
		-e "s:share/qx11grab:share/doc/${PF}:" \
		-e '/COPYING/d' \
		CMakeLists.txt
}

src_install() {
	cmake-utils_src_install

	prepalldocs
}
