# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A ncurses based music player with plugin support for many formats"
HOMEPAGE="http://onion.dynserv.net/~timo/cmus.html"
SRC_URI="http://onion.dynserv.net/~timo/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="alsa ao arts debug flac mad modplug mp3 musepack oss vorbis"

DEPEND="sys-libs/ncurses
	flac? ( >=media-libs/flac-1.1.2 )
	mad? ( >=media-libs/libmad-0.14 )
	modplug? ( >=media-libs/libmodplug-0.7 )
	mp3? ( >=media-libs/libmad-0.14 )
	musepack? ( >=media-libs/libmpcdec-1.2 )
	vorbis? ( >=media-libs/libvorbis-1.0 )
	alsa? ( >=media-libs/alsa-lib-1.0.11 )
	ao? (  media-libs/libao )
	arts? ( kde-base/arts )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! built_with_use sys-libs/ncurses unicode
	then
		ewarn
		ewarn "\t sys-libs/ncurses compiled without the unicode USE flag."
		ewarn "\t Please recompile sys-libs/ncurses with USE=unicode and emerge"
		ewarn "\t cmus again if you experience any problems with UTF-8 or"
		ewarn "\t wide characters."
		ewarn
		epause
	fi
}

my_config() {
	local value
	use ${1} && value=y || value=n
	myconf="${myconf} ${2}=${value}"
}

src_compile() {
	local debuglevel myconf

	use debug && debuglevel=2 || debuglevel=1

	myconf="CONFIG_SUN=n"
	my_config ao CONFIG_AO
	my_config alsa CONFIG_ALSA
	my_config arts CONFIG_ARTS
	my_config flac CONFIG_FLAC
	my_config oss CONFIG_OSS
	my_config mp3 CONFIG_MAD
	my_config mad CONFIG_MAD
	my_config modplug CONFIG_MODPLUG
	my_config musepack CONFIG_MPC
	my_config vorbis CONFIG_VORBIS

	# econf doesn't work, because configure wants "prefix" without dashes
	./configure prefix=/usr ${myconf} DEBUG=$debuglevel || die "configure failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README
}
