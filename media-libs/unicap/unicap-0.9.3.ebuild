# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="The uniform API for image acquisition devices"
HOMEPAGE="http://unicap-imaging.org/"
SRC_URI="http://unicap-imaging.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug gtk ieee1394 nls png theora threads v4l v4l2"

DEPEND="alsa? ( media-libs/alsa-lib )
	gtk? ( >=x11-libs/gtk+-2.0 )
	ieee1394? ( >=sys-libs/libraw1394-0.10.0 )
	theora? ( media-libs/libtheora )"
RDEPEND=${DEPEND}

src_configure() {
	local myconf

	if use debug ; then
		myconf="${myconf} --enable-thing --enable-debug-unicap
			--enable-debug-ucil --enable-debug-thing"
		use gtk && myconf="${myconf} --enable-debug-unicapgtk"
		use ieee1394 && myconf="${myconf} --enable-debug-dcam
			--enable-debug-vid21394"
		use v4l && myconf="${myconf} --enable-debug-v4l"
		use v4l2 && myconf="${myconf} --enable-debug-v4l2"
	fi

	econf ${myconf} \
		$(use_enable alsa ucil-alsa) \
		$(use_enable gtk unicapgtk) \
		$(use_enable ieee1394 dcam) \
		$(use_enable ieee1394 vid21394) \
		$(use_enable nls) \
		$(use_enable png ucil-png) \
		$(use_enable theora ucil-theora) \
		$(use_enable threads unicap-threads) \
		$(use_enable v4l) \
		$(use_enable v4l2) \
		--enable-ucil
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README README.troubleshooting \
		|| die "dodoc failed"
}
