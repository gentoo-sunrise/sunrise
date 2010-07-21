# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

GCONF_DEBUG="no"
SCROLLKEEPER_UPDATE="no"

inherit eutils gnome2

DESCRIPTION="Manage your collections of movies, games, books, music and more"
HOMEPAGE="http://www.gcstar.org/"
SRC_URI="http://download.gna.org/gcstar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cddb gnome mp3 spell tellico vorbis"

LANGS="ar bg ca cs de el es fr gl hu id it nl pl pt ro ru sr sv tr uk"
for x in ${LANGS} ; do
	IUSE="${IUSE} linguas_${x}"
done

DEPEND="dev-lang/perl
		dev-perl/Archive-Zip
		dev-perl/DateTime-Format-Strptime
		dev-perl/gtk2-perl
		dev-perl/HTML-Parser
		dev-perl/libwww-perl
		dev-perl/URI
		dev-perl/XML-Parser
		dev-perl/XML-Simple
		virtual/perl-Archive-Tar
		virtual/perl-Encode
		virtual/perl-Getopt-Long
		virtual/perl-File-Path
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO-Compress
		virtual/perl-libnet
		virtual/perl-Storable
		virtual/perl-Time-Piece
		cddb? ( dev-perl/Net-FreeDB )
		gnome? ( dev-perl/gnome2-vfs-perl )
		mp3? ( dev-perl/MP3-Info dev-perl/MP3-Tag )
		spell? ( dev-perl/gtk2-spell )
		tellico? ( virtual/perl-Digest-MD5
			virtual/perl-MIME-Base64 )
		vorbis? ( dev-perl/Ogg-Vorbis-Header-PurePerl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.4.0-man.patch"
}

src_configure() {
	# do nothing (otherwise gnome2_src_configure would get called)
	return
}

src_compile() {
	# do nothing (otherwise gnome2_src_compile would get called)
	return
}

src_install() {
	cd "${S}"/lib/gcstar/GCLang

	mkdir tmp
	mv ?? tmp
	# English version should be always available so we will keep it
	mv tmp/EN .

	for x in ${LINGUAS}; do
		# GCstar uses upper-case language names
		mv tmp/$(echo ${x} | tr '[:lower:]' '[:upper:]') .
	done

	rm -rf tmp

	cd "${S}"
	./install --prefix="${ED}usr" \
		--noclean --nomenu || die "install script failed"

	domenu share/applications/gcstar.desktop
	for size in 16x16 22x22 24x24 32x32 36x36 48x48 64x64 72x72 96x96 128x128
	do
		insinto ${EPREFIX}/usr/share/icons/hicolor/${size}/apps
		newins share/gcstar/icons/gcstar_${size}.png gcstar.png
	done
	insinto ${EPREFIX}/usr/share/icons/hicolor/scalable/apps
	newins share/gcstar/icons/gcstar_scalable.svg gcstar.svg
	insinto ${EPREFIX}/usr/share/mime/packages
	doins share/applications/gcstar.xml

	dodoc CHANGELOG README

	if use linguas_fr; then
		dodoc CHANGELOG.fr README.fr
	fi
}
