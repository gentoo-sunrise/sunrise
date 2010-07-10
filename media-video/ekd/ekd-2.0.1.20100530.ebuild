# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND="2:2.5"

inherit eutils python versionator

format_version_string() {
	local fstr=$1
	set -- $(get_version_components)
	eval echo "${fstr}"
}

MY_P=$(format_version_string '${PN}_linux_source_${1}_${2}-${3}_${4}')
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

S=${WORKDIR}/${MY_P}

src_prepare() {
	python_convert_shebangs 2 ekd_gui.py

	# Upstream's configure/Makefile just mindlessly copies the files over
	# and using it requires much more effort than doing that by hand.
	rm -f configure.in Makefile.in || die
}

src_install() {
	insinto /usr/share/${PN}
	doins -r * || die

	fperms +x /usr/share/${PN}/ekd_gui.py || die
	make_wrapper ${PN} ./ekd_gui.py /usr/share/${PN}

	dodoc README_LISEZMOI.txt || die

	doicon icone_${PN}.png || die
	make_desktop_entry ${PN} EKD icone_${PN}
}
