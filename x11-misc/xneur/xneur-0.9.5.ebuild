# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools

DESCRIPTION="In-place conversion of text typed in with a wrong keyboard layout (Punto Switcher replacement)"
HOMEPAGE="http://www.xneur.ru/"
SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aplay debug +gstreamer +imlib libnotify nls openal xosd +pcre spell xpm"

# Sound does not works here with media-sound/alsa-utils-1.0.16
RDEPEND=">=x11-libs/libX11-1.1
	x11-libs/libXtst
	imlib? ( media-libs/imlib2 )
	!imlib? ( xpm? ( x11-libs/libXpm ) )
	gstreamer? ( >=media-libs/gstreamer-0.10.6 )
	!gstreamer? ( openal? ( >=media-libs/freealut-1.0.1 )
				  !openal? ( aplay? ( >=media-sound/alsa-utils-1.0.17 ) ) )
	pcre? ( >=dev-libs/libpcre-5.0 )
	spell? ( app-text/aspell )
	xosd? ( x11-libs/xosd )
	libnotify? ( >=x11-libs/libnotify-0.4.0 )"
DEPEND="${RDEPEND}
	gstreamer? ( media-libs/gst-plugins-good
			media-plugins/gst-plugins-alsa )
	nls? ( sys-devel/gettext )
	>=dev-util/pkgconfig-0.20"

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc44.patch"
	rm ltmain.sh aclocal.m4	m4/{lt~obsolete,ltoptions,ltsugar,ltversion,libtool}.m4
	sed -i -e "s/-Werror -g0//" configure.in
	eautoreconf
}

src_configure() {
	local myconf

	if use gstreamer; then
		elog "Using gstreamer for sound output."
		myconf="--with-sound=gstreamer"
	elif use openal; then
		elog "Using openal for sound output."
		myconf="--with-sound=openal"
	elif use aplay; then
		elog "Using aplay for sound output."
		myconf="--with-sound=aplay"
	else
		myconf="--with-sound=no"
	fi

	if use imlib2; then
		myconf="${myconf} --with-image=imlib2"
	elif use xpm; then
		myconf="${myconf} --with-image=xpm"
	else
		myconf="${myconf} --with-image=no"
	fi

	econf ${myconf} \
		$(use_with debug) \
		$(use_enable nls) \
		$(use_with pcre) \
		$(use_with spell aspell) \
		$(use_with xosd) \
		$(use_with libnotify)
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog README NEWS TODO || die
}

pkg_postinst() {
	elog "This is command line tool. If you are looking for GUI frontend just"
	elog "emerge gxneur, which uses xneur transparently as backend."

	ewarn "If you upgraded from <=xneur-0.9.3, you need to remove"
	ewarn "dictionary files in the home directory:"
	ewarn " $ rm ~/.xneur/{ru,en,be,etc.}/dict"
}
