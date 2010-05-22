# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Overlays text and graphics on video images"
HOMEPAGE="http://unicap-imaging.org/"
SRC_URI="http://unicap-imaging.org/downloads/lib${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug doc nls png theora"

RDEPEND="dev-libs/glib:2
	~media-libs/unicap-${PV}
	x11-libs/pango
	alsa? ( media-libs/alsa-lib )
	nls? ( virtual/libintl )
	png? ( media-libs/libpng )
	theora? ( media-libs/libtheora )"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )"

S=${WORKDIR}/lib${P}

src_prepare() {
	# patch submitted upstream at https://bugs.launchpad.net/unicap/+bug/584164
	epatch "${FILESDIR}/libpng14.patch"
}

src_configure() {
	# The Unicap author recommended leaving avcodec (ffmpeg) support disabled:
	# http://unicap-imaging.org/blog/index.php?/archives/20-Unicap-0.9.3-and-UCView-0.22-released.html#c46

	econf --disable-ucil-avcodec \
		$(use_enable alsa ucil-alsa) \
		$(use_enable debug debug-ucil) \
		$(use_enable doc gtk-doc) \
		$(use_enable nls) \
		$(use_enable png ucil-png) \
		$(use_enable theora ucil-theora)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README || die
}
