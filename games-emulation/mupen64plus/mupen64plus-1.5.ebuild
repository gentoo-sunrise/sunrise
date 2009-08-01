# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils flag-o-matic games

MY_P="Mupen64Plus-${PV/./-}-src"

DESCRIPTION="A fork of Mupen64 Nintendo 64 emulator"
HOMEPAGE="http://code.google.com/p/mupen64plus/"
SRC_URI="http://mupen64plus.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gtk libsamplerate lirc qt4 sse"

# GTK+ is currently required by plugins even if no GUI support is enabled
RDEPEND="virtual/opengl
	media-libs/freetype:2
	media-libs/libpng
	media-libs/libsdl
	media-libs/sdl-ttf
	sys-libs/zlib
	x11-libs/gtk+:2
	libsamplerate? ( media-libs/libsamplerate )
	lirc? ( app-misc/lirc )
	qt4? ( x11-libs/qt-gui:4
		x11-libs/qt-core:4 )"

DEPEND="${RDEPEND}
	dev-lang/yasm
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! use gtk && ! use qt4; then
		ewarn "Building ${PN} without any GUI! To get one, enable USE=gtk or USE=qt4."
	elif use gtk && use qt4; then
		ewarn "Only one GUI can be built, using GTK+ one."
	fi

	games_pkg_setup
}

src_prepare() {
	# unbundle bzip2
	epatch "${FILESDIR}"/${P}-unbundle-bzip2.patch
	# XXX: try to unbundle more?

	# fix compilation with gcc4.4
	epatch "${FILESDIR}"/${P}-glide64-gcc44.patch

	# first prepare to replace plugin path
	epatch "${FILESDIR}"/${P}-plugindir.patch

	# disable stripping, don't replace CFLAGS
	epatch "${FILESDIR}"/${P}-flags.patch

	# and then do real path replace
	sed -i \
		-e "s:/usr/local/share/mupen64plus:${GAMES_DATADIR}/mupen64plus:" \
		-e "s:%PUT_PLUGIN_PATH_HERE%:$(games_get_libdir)/${PN}/plugins/:" \
		main/main.c || die "sed failed"

	# replace absolute icon path with relative one
	sed -i -e "s:^Icon=.*$:Icon=${PN}:" \
		${PN}.desktop.in || die "sed failed"
}

get_opts() {
	use libsamplerate || echo -n "NO_RESAMP=1 "
	use lirc && echo -n "LIRC=1 "
	use sse || echo -n "NO_ASM=1 "

	echo -n GUI=
	if use gtk; then
		echo -n GTK2
	elif use qt4; then
		echo -n QT4
	else
		echo -n NONE
	fi
}

src_compile() {
	emake $(get_opts) all || die "make failed"
}

src_install() {
	# These are:
	# 1) prefix - not used really, printed only
	# 2) SHAREDIR
	# 3) BINDIR
	# 4) 'LIBDIR' - where to put plugins in
	# 5) 'MANDIR' - exact directory to put man file in
	# 6) APPLICATIONSDIR - where to put .desktop in

	./install.sh "${D}" \
		"${D}${GAMES_DATADIR}/${PN}" \
		"${D}${GAMES_BINDIR}" \
		"${D}$(games_get_libdir)/${PN}/plugins" \
		"${D}/usr/share/man/man1" \
		"${D}/usr/share/applications" \
		|| or die "install.sh failed"

	# Copy icon into system-wide location
	newicon icons/mupen64plus-large.png ${PN}.png || die "newicon failed"

	# 'Move' docs into correct dir
	rm -r "${D}${GAMES_DATADIR}/${PN}/doc"
	dodoc README RELEASE TODO doc/*.txt || die "dodoc failed"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if use lirc; then
		elog "For lirc configuration see:"
		elog "http://code.google.com/p/mupen64plus/wiki/LIRC"
	fi
}
