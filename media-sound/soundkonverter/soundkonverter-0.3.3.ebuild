# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde qt3

DESCRIPTION="a frontend to various audio converters for KDE"
HOMEPAGE="http://kde-apps.org/content/show.php?content=29024"
SRC_URI="http://hessijames.googlepages.com/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac arts kdeenablefinal"

DEPEND=">=media-libs/taglib-1.4
	>=media-sound/cdparanoia-3.9.8-r5
	$(qt_min_version 3.3.4)
	aac? ( media-libs/libmp4v2 )"

RDEPEND="${DEPEND}"

need-kde 3.5

src_compile() {
	local myconf="$(use_with aac mp4v2)
			$(use_enable kdeenablefinal final)
			$(use_with arts)"
	kde_src_compile || die "Compile error"
}

src_install() {
	kde_src_install || die "Installation failed"
	mv "${D}"/usr/share/doc/HTML "${D}"/usr/share/doc/${PF}/html
}

pkg_postinst() {
	echo
	elog "For AmaroK users there is a script included with this package."
	elog "You can enable it with the Script Manager tool in Amarok."
	elog "This program supports various encoders and codecs."
	elog "For example you might want to install lame, ffmpeg, vorbis, flac "
	elog "and/or musepack."
	echo
}
