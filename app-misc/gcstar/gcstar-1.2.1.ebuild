# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="GCstar is a free open source application for managing your collections."
HOMEPAGE="http://www.gcstar.org/"
SRC_URI="http://download.gna.org/gcstar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mp3 tellico vorbis"

RDEPEND="dev-lang/perl
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
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-libnet
		mp3? ( dev-perl/MP3-Info dev-perl/MP3-Tag )
		tellico? ( dev-perl/Archive-Zip
			virtual/perl-Digest-MD5
			virtual/perl-MIME-Base64 )
		vorbis? ( dev-perl/Ogg-Vorbis-Header-PurePerl )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	# otherwise man pages would get installed in /usr/man
	mv man share
	./install --prefix="${D}/usr" --noclean --nomenu || die
	domenu share/applications/gcstar.desktop
	newicon share/gcstar/icons/gcstar_64x64.png gcstar.png
	dodoc CHANGELOG README
	doman share/man/gcstar.1
}
