# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Macromedia Flash decoding library"
HOMEPAGE="http://swfdec.freedesktop.org"
SRC_URI="http://swfdec.freedesktop.org/download/${PN}/${PV:0:3}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="ffmpeg gstreamer gnome mad"

RESTRICT="test"

RDEPEND=">=dev-libs/glib-2
	>=dev-libs/liboil-0.3.10-r1
	x11-libs/pango
	net-libs/libsoup
	>=x11-libs/cairo-1.2
	>=x11-libs/gtk+-2.0
	>=media-libs/alsa-lib-1.0.12
	ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20070330)
	mad? ( >=media-libs/libmad-0.15.1b )
	gstreamer? ( >=media-libs/gstreamer-0.10.11 )
	gnome? ( gnome-base/gnome-vfs )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	if use ppc && use ffmpeg ; then
		eerror "swfdec doesn't work with latest ffmpeg version in"
		eerror "ppc arch. See bug #11841 in Freedesktop Bugzilla."
		eerror "Please disable ffmpeg flag and enable gstreamer"
		die "Depends failed"
	fi
	if use !gnome ; then
		ewarn "In order to compile libswfdec-gtk with Gnome-VFS"
		ewarn "support you must have 'gnome' USE flag enabled"
	fi
}

src_compile() {
	econf \
		$(use_enable gstreamer) \
		$(use_enable ffmpeg) \
		$(use_enable mad) \
		$(use_enable gnome gnome-vfs) 
	# parallel build doesn't work, so specify -j1
	emake -j1 || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog README
}
