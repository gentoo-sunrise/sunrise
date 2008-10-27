# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils

DESCRIPTION="BMPanel (BitMap Panel) is a lightweight, NETWM compliant panel for
X11 Window System."
HOMEPAGE="http://nsf.110mb.com/bmpanel"
SRC_URI="http://nsf.110mb.com/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc"
IUSE="debug libev libevent"

RDEPEND=">=media-libs/imlib2-1.4.0
	media-libs/freetype:2
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXcomposite
	x11-libs/libXfixes
	media-libs/fontconfig
	libev? ( dev-libs/libev  )
	libevent? ( dev-libs/libevent )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	# event loop stuff in glibc-2.8_p20080602 seems to be broken
	if ! use libev && ! use libevent ; then
		eerror "you need at least the libev or libevent useflag"
		die "no libev or libevent useflag defined"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/Makefile-no-strip.patch"
}

src_compile() {
	# the provided configure script is broken.
	# it doesn't provide --disable-foo etc. so we can't use econf here.
	local myconf="--prefix=/usr --ugly"

	use debug && myconf="${myconf} --debug"
	use libev && myconf="${myconf} --with-ev"
	use libevent && myconf="${myconf} --with-event"

	./configure ${myconf} || die "configure failed"

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"

	dodoc AUTHORS README
}
