# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit  base eutils

DESCRIPTION="An automated system for acquisition, management, scheduling and playout of audio content."
HOMEPAGE="http://rivendellaudio.org/"
SRC_URI="http://rivendellaudio.org/ftpdocs/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="alsa jack pam"

DEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	media-libs/flac
	media-libs/id3lib
	media-libs/libogg
	media-libs/libsamplerate
	media-libs/libvorbis
	virtual/mysql
	x11-libs/qt:3"
RDEPEND="${DEPEND}
	pam? ( sys-libs/pam )
	app-cdr/cdrkit
	media-sound/cdparanoia
	media-sound/lame
	media-sound/mpg321
	media-sound/sox
	media-sound/vorbis-tools
	net-ftp/lftp
	net-misc/wget
	sys-devel/bc"

PATCHES=( "${FILESDIR}/${PN}-init.patch"
	"${FILESDIR}/${PN}-sandbox.patch"
	"${FILESDIR}/${PN}-sox.patch" )

src_compile() {
	local myconf=""

	use alsa || myconf="${myconf} --disable-alsa"
	use jack || myconf="${myconf} --disable-jack"
	use pam || myconf="${myconf} --disable-pam"

	econf ${myconf}
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	insinto /etc
	doins conf/rd.conf-sample || die

	keepdir /var/snd || die
	fperms 777 /var/snd || die

	dodoc AUTHORS ChangeLog NEWS README SupportedCards docs/*.txt || die
	prepalldocs
}

pkg_postinst() {
	elog "If you would like ASI or GPIO hardware support, install"
	elog "their drivers and re-emerge this package. If you would"
	elog "like the RDFeed RSS Podcast module to work, you'll need"
	elog "www-servers/apache"
	einfo
	einfo "If this is a fresh install you will need to modify"
	einfo "the /etc/rd.conf file and use rdadmin to initialize"
	einfo "the Rivendell database. Don't forget to make sure you"
	einfo "start /etc/init.d/rivendell."
	einfo
	ewarn "If this is an upgrade, run rdadmin to ensure your"
	ewarn "database schema is up to date"
}
