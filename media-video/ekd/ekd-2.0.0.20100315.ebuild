# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"

inherit eutils python versionator

MY_PV=$(replace_version_separator 1 '_' $(replace_version_separator 2 '-' $(replace_version_separator 3 '_')))
MY_P=${PN}_linux_source_${MY_PV}

DESCRIPTION="Post-production video editing"
HOMEPAGE="http://ekd.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/${PN}forum/${PN}/appli/linux/sources/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="virtual/libintl
	dev-python/imaging
	dev-python/numpy
	dev-python/PyQt4[X]
	media-gfx/imagemagick
	media-video/ffmpeg2theora
	media-video/mjpegtools
	media-video/mplayer
	media-sound/lame
	media-sound/sox"
RESTRICT_PYTHON_DEPEND="2.4 3*"

S=${WORKDIR}/${MY_P}

src_prepare() {
	python_convert_shebangs 2 ekd_gui.py
}

src_install() {
	insinto /usr/share/${PN}
	doins -r * || die

	building() {
		make_wrapper ekd-${PYTHON_ABI} "$(PYTHON) /usr/share/${PN}/ekd_gui.py"
	}
	python_execute_function building

	python_generate_wrapper_scripts "${D}/usr/bin/ekd"

	dodoc README_LISEZMOI.txt || die

	doicon icone_${PN}.png || die
	make_desktop_entry ${PN} EKD icone_${PN}
}
