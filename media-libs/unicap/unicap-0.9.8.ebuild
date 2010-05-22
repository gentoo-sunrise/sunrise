# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="The uniform API for image acquisition devices"
HOMEPAGE="http://unicap-imaging.org/"
SRC_URI="http://unicap-imaging.org/downloads/lib${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc ieee1394 libv4l nls threads v4l v4l2"

RDEPEND="ieee1394? ( sys-libs/libraw1394 )
	nls? ( virtual/libintl )
	v4l2? ( libv4l? ( media-libs/libv4l ) )"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )"

S=${WORKDIR}/lib${P}

src_configure() {
	local -a myconf

	if use debug ; then
		# thing is presently broken (sloppy upstream)
		#myconf=( --enable-thing )
		myconf+=( --enable-debug-unicap --enable-debug-ucil --enable-debug-thing )
		use ieee1394 && myconf+=( --enable-debug-dcam --enable-debug-vid21394 )
		use v4l && myconf+=( --enable-debug-v4l )
		use v4l2 && myconf+=( --enable-debug-v4l2 )
	fi

	econf "${myconf[@]}" \
		$(use_enable doc gtk-doc) \
		$(use_enable ieee1394 dcam) \
		$(use_enable ieee1394 vid21394) \
		$(use_enable libv4l ) \
		$(use_enable nls) \
		$(use_enable threads unicap-threads) \
		$(use_enable v4l) \
		$(use_enable v4l2)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README || die
}
