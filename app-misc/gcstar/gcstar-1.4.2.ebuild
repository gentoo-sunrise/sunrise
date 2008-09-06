# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GCONF_DEBUG="no"
SCROLLKEEPER_UPDATE="no"

inherit eutils gnome2

DESCRIPTION="GCstar is a personal collections manager."
HOMEPAGE="http://www.gcstar.org/"
SRC_URI="http://download.gna.org/gcstar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cddb gnome mp3 spell tellico vorbis"

LANGS="ar bg ca cs de el es fr gl hu id it pl pt ro ru sr sv tr uk"
for x in ${LANGS} ; do
	IUSE="${IUSE} linguas_${x}"
done

DEPEND="dev-lang/perl
		dev-perl/Archive-Tar
		dev-perl/Archive-Zip
		dev-perl/Compress-Zlib
		dev-perl/gtk2-perl
		dev-perl/HTML-Parser
		dev-perl/libwww-perl
		dev-perl/URI
		dev-perl/XML-LibXML
		dev-perl/XML-Parser
		dev-perl/XML-Simple
		dev-perl/Archive-Tar
		dev-perl/Compress-Zlib
		dev-perl/Time-Piece
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-libnet
		cddb? ( dev-perl/Net-FreeDB )
		gnome? ( dev-perl/gnome2-vfs-perl )
		mp3? ( dev-perl/MP3-Info dev-perl/MP3-Tag )
		spell? ( dev-perl/gtk2-spell )
		tellico? ( dev-perl/Archive-Zip
			virtual/perl-Digest-MD5
			virtual/perl-MIME-Base64 )
		vorbis? ( dev-perl/Ogg-Vorbis-Header-PurePerl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-1.4.0-man.patch"
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

	for x in ${LANGS}; do
		# GCstar uses upper-case language names
		if use linguas_${x} ; then
			mv tmp/$(echo ${x} | tr '[:lower:]' '[:upper:]') .
		fi
	done

	rm -rf tmp

	cd "${S}"
	./install --prefix="${D}/usr" \
		--noclean --nomenu || die "install script failed"

	domenu share/applications/gcstar.desktop
	newicon share/gcstar/icons/gcstar_64x64.png gcstar.png
	insinto /usr/share/mime/packages
	doins share/applications/gcstar.xml

	dodoc CHANGELOG README

	if use linguas_fr; then
		dodoc CHANGELOG.fr README.fr
	fi
}
