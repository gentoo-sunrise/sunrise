# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic kde qt3

DESCRIPTION="SoundKonverter: a frontend to various audio converters for KDE"
HOMEPAGE="http://kde-apps.org/content/show.php?content=29024"
SRC_URI="http://hessijames.googlepages.com/soundkonverter-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="kdeenablefinal arts"

# This line should be added to "DEPEND" when the aac-mp4v2 gets fixed (see
# bug #107189):
# aac?      ( media-libs/libmp4v2 )

DEPEND=">=media-libs/taglib-1.4
	>=media-sound/cdparanoia-3.9.8-r5
	$(qt_min_version 3.3.4)"
RDEPEND="${DEPEND}"

need-kde 3.5

src_compile() {
	append-flags -fno-inline
	local myconf="$(use_enable kdeenablefinal final) $(use_with arts)" # $(use_with aac mp4v2)
	kde_src_compile
}

src_install() {
	kde_src_install || die "Installation failed"
	mv "${D}"/usr/share/doc/HTML "${D}"/usr/share/doc/${PF}/html
}

pkg_postinst() {
	elog
	elog "  The audio USE flags are for your convience, but are not required."
	elog "	For AmaroK users there is a script included with this package."
	elog "	You can enable it with the Script Manager tool in Amarok."
	elog "  This program supports various encoders and codecs."
	elog "  For example you might want to install lame, ffmpeg, vorbis, flac,"
	elog "  timidity and/or musepack."
	elog
}
